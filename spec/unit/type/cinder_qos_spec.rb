require 'puppet'
require 'puppet/type/cinder_qos'

describe Puppet::Type.type(:cinder_qos) do

  before :each do
    Puppet::Type.rmtype(:cinder_qos)
  end

  it 'should reject an invalid property value' do
    incorrect_input = {
      :name       => 'test_qos',
      :properties => ['some_key1 = some_value2']
    }
    expect { Puppet::Type.type(:cinder_qos).new(incorrect_input) }.to raise_error(Puppet::ResourceError, /Parameter properties failed/)
  end

  it 'should default to no properties and no associations' do
    catalog = Puppet::Resource::Catalog.new
    anchor = Puppet::Type.type(:anchor).new(:name => 'cinder::service::end')
    correct_input = {
      :name       => 'test_qos',
    }
    cinder_qos = Puppet::Type.type(:cinder_qos).new(correct_input)
    expect(cinder_qos[:properties]).to eq([])
    expect(cinder_qos[:associations]).to eq([])

    catalog.add_resource anchor, cinder_qos
    dependency = cinder_qos.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(cinder_qos)
    expect(dependency[0].source).to eq(anchor)
  end


  it 'should autorequire cinder-api service' do
    catalog = Puppet::Resource::Catalog.new
    anchor = Puppet::Type.type(:anchor).new(:name => 'cinder::service::end')
    properties = ['read_iops=value1', 'write_iops=value2']
    correct_input = {
      :name       => 'test_qos',
      :properties => properties,
    }
    cinder_qos = Puppet::Type.type(:cinder_qos).new(correct_input)
    expect(cinder_qos[:properties]).to eq(properties)

    catalog.add_resource anchor, cinder_qos
    dependency = cinder_qos.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(cinder_qos)
    expect(dependency[0].source).to eq(anchor)
  end
end
