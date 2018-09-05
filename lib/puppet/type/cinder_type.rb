Puppet::Type.newtype(:cinder_type) do

  desc 'Type for managing cinder types.'

  ensurable

  newparam(:name, :namevar => true) do
    newvalues(/\S+/)
  end

  newproperty(:properties, :array_matching => :all) do
    desc 'The properties of the cinder type. Should be an array, all items should match pattern <key=value1[,value2 ...]>'
    defaultto []
    def insync?(is)
      return false unless is.is_a? Array
      is.sort == should.sort
    end
    validate do |value|
      raise ArgumentError, "Properties doesn't match" unless value.match(/^\s*[^=\s]+=[^=\s]+$/)
    end
  end

  newparam(:is_public, :boolean => true) do
    desc 'Whether the type is public or not. Default to `true`'
    newvalues(:true, :false)
    defaultto true
  end

  newproperty(:access_project_ids,  :array_matching => :all) do
    desc 'Project ids which have access to private cinder type. Should be an array, [project1, project2, ...]'
    def insync?(is)
      return false unless is.is_a? Array
      is.sort == should.sort
    end
  end

  autorequire(:anchor) do
    ['cinder::service::end']
  end
end
