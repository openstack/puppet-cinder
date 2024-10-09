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
    if resource[:properties]
      resource[:properties].each do |k, v|
        properties << '--property' << "#{k}=#{v}"
      end
    end
    properties << name
    self.class.request('volume qos', 'create', properties)
    @property_hash[:ensure] = :present
    @property_hash[:properties] = resource[:properties]
    @property_hash[:consumer] = resource[:consumer]
    @property_hash[:name] = name
    resource[:associations].each do |item|
      self.class.request('volume qos', 'associate', [name, item])
    end
    @property_hash[:associations] = resource[:associations]
  end

  def destroy
    self.class.request('volume qos', 'delete', name)
    @property_hash.clear
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def properties=(value)
    added = []
    @property_hash[:properties].each do |k, v|
      if value[k] != v
        added << '--property' << "#{k}=#{value[k]}"
      end
    end
    unless added.empty?
      self.class.request('volume type', 'set', [properties, added])
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
        :properties   => parse_python_dict(properties),
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
    return input[1..-2].delete("'").split(/,\s/)
  end
end
