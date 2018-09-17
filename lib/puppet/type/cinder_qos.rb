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

  newproperty(:properties, :array_matching => :all) do
    desc 'The Properties of the cinder qos. Should be an array'
    defaultto []
    def insync?(is)
      return false unless is.is_a? Array
      is.sort == should.sort
    end
    validate do |value|
      raise ArgumentError, "Properties doesn't match" unless value.match(/^\s*[^=\s]+=[^=\s]+$/)
    end
  end

  newparam(:consumer) do
    desc 'The consumer QOS'
    defaultto('')
  end

  autorequire(:anchor) do
    ['cinder::service::end']
  end
end
