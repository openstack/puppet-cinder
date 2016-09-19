require 'puppet'
require 'puppet/type/cinder_type'

describe Puppet::Type.type(:cinder_type) do

  before :each do
    Puppet::Type.rmtype(:cinder_type)
  end

  it 'should reject an invalid property value' do
    incorrect_input = {
      :name       => 'test_type',
      :properties => ['some_key1 = some_value2']
    }
    expect { Puppet::Type.type(:cinder_type).new(incorrect_input) }.to raise_error(Puppet::ResourceError, /Parameter properties failed/)
  end

  it 'should default to no properties' do
    catalog = Puppet::Resource::Catalog.new
    anchor = Puppet::Type.type(:anchor).new(:name => 'cinder::service::end')
    correct_input = {
      :name       => 'test_type',
    }
    cinder_type = Puppet::Type.type(:cinder_type).new(correct_input)
    expect(cinder_type[:properties]).to eq([])

    catalog.add_resource anchor, cinder_type
    dependency = cinder_type.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(cinder_type)
    expect(dependency[0].source).to eq(anchor)
  end


  it 'should autorequire cinder-api service' do
    catalog = Puppet::Resource::Catalog.new
    anchor = Puppet::Type.type(:anchor).new(:name => 'cinder::service::end')
    properties = ['some_key1=value', 'some_key2=value1,value2']
    correct_input = {
      :name       => 'test_type',
      :properties => properties,
    }
    cinder_type = Puppet::Type.type(:cinder_type).new(correct_input)
    expect(cinder_type[:properties]).to eq(properties)

    catalog.add_resource anchor, cinder_type
    dependency = cinder_type.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(cinder_type)
    expect(dependency[0].source).to eq(anchor)
  end
end
