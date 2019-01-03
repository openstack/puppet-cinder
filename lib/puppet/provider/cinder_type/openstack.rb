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
    properties << (@resource[:is_public] == :true ? '--public' : '--private')
    properties << name
    self.class.request('volume type', 'create', properties)
    @property_hash[:ensure] = :present
    @property_hash[:properties] = resource[:properties]
    @property_hash[:is_public] = resource[:is_public]
    @property_hash[:name] = name
    unless @resource[:access_project_ids].nil?
      set_access_project_ids(resource[:access_project_ids])
      @property_hash[:access_project_ids] = resource[:access_project_ids]
    end
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

  def access_project_ids=(value)
    added = value - @property_hash[:access_project_ids]
    set_access_project_ids(added)
    removed = @property_hash[:access_project_ids] - value
    unset_access_project_ids(removed)
    unless access_project_ids.empty?
      @property_hash[:access_project_ids] = value
    end
  end

  def set_access_project_ids(projects)
    opts = []
    projects.each do |project|
      opts << '--project' << project
      self.class.request('volume type', 'set', [opts, @resource[:name]])
    end
  end

  def unset_access_project_ids(projects)
    opts = []
    projects.each do |project|
      opts << '--project' << project
      self.class.request('volume type', 'unset', [opts, @resource[:name]])
    end
  end

  def self.instances
    list = request('volume type', 'list', '--long')
    list.each do |type|
      if type[:is_public] == 'False'
        type_details = request('volume type', 'show', type[:id])
        type[:access_project_ids] = string2array(type_details[:access_project_ids])
        type[:is_public] = false
      else
        type[:access_project_ids] = []
        type[:is_public] = true
      end
    end

    list.collect do |type|
      new({
        :name               => type[:name],
        :ensure             => :present,
        :id                 => type[:id],
        :properties         => string2array(type[:properties]),
        :is_public          => type[:is_public],
        :access_project_ids => type[:access_project_ids]
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
