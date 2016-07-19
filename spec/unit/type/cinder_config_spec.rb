require 'puppet'
require 'puppet/type/cinder_config'

describe 'Puppet::Type.type(:cinder_config)' do
  before :each do
    @cinder_config = Puppet::Type.type(:cinder_config).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  it 'should autorequire the package that install the file' do
    catalog = Puppet::Resource::Catalog.new
    anchor = Puppet::Type.type(:anchor).new(:name => 'cinder::install::end')
    catalog.add_resource anchor, @cinder_config
    dependency = @cinder_config.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(@cinder_config)
    expect(dependency[0].source).to eq(anchor)
  end

end
