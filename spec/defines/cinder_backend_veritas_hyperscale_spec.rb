require 'spec_helper'

describe 'cinder::backend::veritas_hyperscale' do
  let (:title) { 'Veritas_HyperScale' }

  let :params do
    {
      :backend_availability_zone => 'my_zone',
      :manage_volume_type        => true,
    }
  end

  shared_examples 'cinder::backend::veritas_hyperscale' do
    it { should contain_cinder_config("#{title}/volume_driver").with(
      :value => 'cinder.volume.drivers.veritas.vrtshyperscale.HyperScaleDriver'
    )}

    it {
      should contain_cinder_config("#{title}/volume_backend_name").with_value(title)
      should contain_cinder_config("#{title}/backend_availability_zone").with_value('my_zone')
      should contain_cinder_config("#{title}/image_volume_cache_enabled").with_value(true)
    }

    context 'veritas_hyperscale backend with additional configuration' do
      before do
        params.merge!( :extra_options => {"#{title}/param1" => {'value' => 'value1'}} )
      end

      it { should contain_cinder_config("#{title}/param1").with_value('value1') }
    end

    context 'veritas_hyperScale backend with cinder type' do
      before :each do
        params.merge!( :manage_volume_type => true )
      end

      it { should contain_cinder_type(title).with(
        :ensure     => 'present',
        :properties => ["volume_backend_name=#{title}"]
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder::backend::veritas_hyperscale'
    end
  end
end
