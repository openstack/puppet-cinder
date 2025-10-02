Puppet::Type.newtype(:cinder_type) do

  desc 'Type for managing cinder types.'

  ensurable

  newparam(:name, :namevar => true) do
    newvalues(/\S+/)
  end

  newproperty(:properties) do
    desc "The set of volume type properties"
    validate do |value|
      if value.is_a?(Hash)
        return true
      else
        raise ArgumentError, "Invalid properties #{value}. Requires a Hash, not a #{value.class}"
      end
    end
  end

  newproperty(:is_public, :boolean => true) do
    desc 'Whether the type is public or not. Default to `true`'
    newvalues(:true, :false)
    defaultto :true
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
