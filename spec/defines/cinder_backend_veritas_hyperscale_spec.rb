require 'spec_helper'

describe 'cinder::backend::veritas_hyperscale' do

  let (:title) { 'Veritas_HyperScale' }

  let :params do {
      :manage_volume_type => true,
    }
  end

  shared_examples_for 'veritas_hyperscale volume driver' do
    it 'configures veritas_hyperscale volume driver' do
      should contain_cinder_config("#{title}/volume_driver").with_value(
        'cinder.volume.drivers.veritas.vrtshyperscale.HyperScaleDriver')
      should contain_cinder_config("#{title}/volume_backend_name").with_value(
        "#{title}")
    end

    describe 'veritas_hyperscale backend with additional configuration' do
      before do
        params.merge!({:extra_options => {"#{title}/param1" => {'value' => 'value1'}}})
      end

      it 'configure veritas_hyperscale backend with additional configuration' do
        is_expected.to contain_cinder_config("#{title}/param1").with({
          :value => 'value1',
        })
      end
    end
  end

  describe 'veritas_hyperScale backend with cinder type' do
    before :each do
      params.merge!({:manage_volume_type => true})
    end
    it 'should create type with properties' do
      should contain_cinder_type("#{title}").with(
            :ensure => :present, :properties => ["volume_backend_name=#{title}"])
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'veritas_hyperscale volume driver'
    end
  end
end

