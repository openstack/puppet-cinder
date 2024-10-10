Puppet::Type.newtype(:cinder_qos) do

  desc 'Type for managing cinder QOS.'

  ensurable

  newparam(:name, :namevar => true) do
    newvalues(/\S+/)
  end

  newproperty(:associations, :array_matching => :all) do
    desc 'The cinder Types associations. Should be an array'
    defaultto []
    def insync?(is)
      return false unless is.is_a? Array
      is.sort == should.sort
    end
    validate do |value|
      raise ArgumentError, "Types name doesn't match" unless value.match(/^[-\w]+$/)
    end
  end

  newproperty(:properties) do
    desc "The set of volume qos properties"
    validate do |value|
      if value.is_a?(Hash)
        return true
      else
        raise ArgumentError, "Invalid properties #{value}. Requires a Hash, not a #{value.class}"
      end
    end
  end

  newparam(:consumer) do
    desc 'The consumer QOS'
    defaultto('')
  end

  autorequire(:cinder_qos) do
    self[:associations] if self[:associations]
  end

  autorequire(:anchor) do
    ['cinder::service::end']
  end
end
