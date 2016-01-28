require 'puppet'
require 'puppet/type/cinder_type'

describe Puppet::Type.type(:cinder_type) do

  before :each do
    Puppet::Type.rmtype(:cinder_type)
  end

  it 'should reject an invalid propertie value' do
    incorrect_input = {
      :name       => 'test_type',
      :properties => ['some_key1 = some_value2']
    }
    expect { Puppet::Type.type(:cinder_type).new(incorrect_input) }.to raise_error(Puppet::ResourceError, /Parameter properties failed/)
  end

  it 'should autorequire cinder-api service' do
    catalog = Puppet::Resource::Catalog.new
    service = Puppet::Type.type(:service).new(:name => 'cinder-api')
    correct_input = {
      :name       => 'test_type',
      :properties => ['some_key1=value', 'some_key2=value1,value2']
    }
    cinder_type = Puppet::Type.type(:cinder_type).new(correct_input)
    catalog.add_resource service, cinder_type
    dependency = cinder_type.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(cinder_type)
    expect(dependency[0].source).to eq(service)
  end
end
