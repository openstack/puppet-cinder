require File.join(File.dirname(__FILE__), '..','..','..', 'puppet/provider/cinder')

Puppet::Type.type(:cinder_type).provide(
  :openstack,
  :parent => Puppet::Provider::Cinder
) do

  desc 'Provider for cinder types.'

  @credentials = Puppet::Provider::Openstack::CredentialsV3.new

  mk_resource_methods

  def create
    properties = []
    resource[:properties].each do |item|
      properties << '--property' << item
    end
    properties << name
    self.class.request('volume type', 'create', properties)
    @property_hash[:ensure] = :present
    @property_hash[:properties] = resource[:properties]
    @property_hash[:name] = name
  end

  def destroy
    self.class.request('volume type', 'delete', name)
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
      self.class.request('volume type', 'set', [properties, name])
      @property_hash[:properties] = value
    end
  end

  def self.instances
    list = request('volume type', 'list', '--long')
    list.collect do |type|
      new({
        :name       => type[:name],
        :ensure     => :present,
        :id         => type[:id],
        :properties => string2array(type[:properties])
      })
    end
  end

  def self.prefetch(resources)
    types = instances
    resources.keys.each do |name|
      if provider = types.find{ |type| type.name == name }
        resources[name].provider = provider
      end
    end
  end

  def self.string2array(input)
    return input.delete("'").split(/,\s/)
  end
end
