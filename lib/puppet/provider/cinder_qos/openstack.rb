require File.join(File.dirname(__FILE__), '..','..','..', 'puppet/provider/cinder')

Puppet::Type.type(:cinder_qos).provide(
  :openstack,
  :parent => Puppet::Provider::Cinder
) do

  desc 'Provider for cinder QOS.'

  @credentials = Puppet::Provider::Openstack::CredentialsV3.new

  mk_resource_methods

  def create
    properties = []
    unless resource[:consumer].empty?
      properties << '--consumer' << resource[:consumer]
    end
    resource[:properties].each do |item|
      properties << '--property' << item
    end
    properties << name
    self.class.request('volume qos', 'create', properties)
    @property_hash[:ensure] = :present
    @property_hash[:properties] = resource[:properties]
    @property_hash[:consumer] = resource[:consumer]
    @property_hash[:name] = name
    unless resource[:associations].empty?
      resource[:associations].each do |item|
        self.class.request('volume qos', 'associate', [name, item])
      end
      @property_hash[:associations] = resource[:associations]
    end
  end

  def destroy
    self.class.request('volume qos', 'delete', name)
    @property_hash.clear
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def properties=(value)
    properties = []
    (value - @property_hash[:properties]).each do |item|
      properties << '--property' << item
    end
    unless properties.empty?
      self.class.request('volume qos', 'set', [properties, name])
      @property_hash[:properties] = value
    end
  end

  def associations=(value)
    added = value - @property_hash[:associations]
    removed = @property_hash[:associations] - value
    added.each do |item|
      self.class.request('volume qos', 'associate', [name, item])
    end
    removed.each do |item|
      self.class.request('volume qos', 'disassociate', [name, item])
    end
    @property_hash[:associations] = value
  end

  def self.instances
    list = request('volume qos', 'list')
    list.collect do |qos|
      properties = qos[:properties]
      new({
        :name         => qos[:name],
        :ensure       => :present,
        :id           => qos[:id],
        :properties   => pythondict2array(properties),
        :consumer     => qos[:consumer],
        :associations => string2array(qos[:associations])
      })
    end
  end

  def self.prefetch(resources)
    qoss = instances
    resources.keys.each do |name|
      if provider = qoss.find{ |qos| qos.name == name }
        resources[name].provider = provider
      end
    end
  end

  def self.string2array(input)
    return input.delete("'").split(/,\s/)
  end

  def self.pythondict2array(input)
    json_input = JSON.parse(input.gsub(/'/, '"'))
    output = []
    json_input.each do | k, v |
      output = output + ["#{k}=#{v}"]
    end
    return output
  end
end
