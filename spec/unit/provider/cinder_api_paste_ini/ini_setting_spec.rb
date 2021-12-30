require 'spec_helper'
provider_class = Puppet::Type.type(:cinder_api_paste_ini).provider(:ini_setting)
describe provider_class do

  it 'should allow setting to be set explicitly' do
    resource = Puppet::Type::Cinder_api_paste_ini.new(
      {:name => 'dude/foo', :value => 'bar'}
    )
    provider = provider_class.new(resource)
    expect(provider.section).to eq('dude')
    expect(provider.setting).to eq('foo')
  end
end
