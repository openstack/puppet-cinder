require 'spec_helper'

describe 'cinder::backend::solidfire' do
  let (:config_group_name) { 'solidfire' }

  let (:title) { config_group_name }

  let :req_params do
    {
      :san_ip       => '127.0.0.2',
      :san_login    => 'solidfire_login',
      :san_password => 'password',
    }
  end

  let :other_params do
    {
      :backend_availability_zone => '<SERVICE DEFAULT>',
      :sf_emulate_512            => '<SERVICE DEFAULT>',
      :sf_allow_tenant_qos       => '<SERVICE DEFAULT>',
      :sf_account_prefix         => '<SERVICE DEFAULT>',
      :sf_template_account_name  => '<SERVICE DEFAULT>',
      :sf_allow_template_caching => '<SERVICE DEFAULT>',
      :sf_api_port               => '<SERVICE DEFAULT>',
      :sf_volume_prefix          => '<SERVICE DEFAULT>',
      :sf_svip                   => '<SERVICE DEFAULT>',
      :sf_enable_volume_mapping  => '<SERVICE DEFAULT>',
      :sf_enable_vag             => '<SERVICE DEFAULT>',
    }
  end

  shared_examples 'cinder::backend::solidfire' do
    context 'SolidFire backend driver with minimal params' do
      let :params do
        req_params
      end

      it { should contain_cinder__backend__solidfire(config_group_name) }
      it { should contain_cinder_config("#{config_group_name}/volume_driver").with(
        :value => 'cinder.volume.drivers.solidfire.SolidFireDriver'
      )}

      it {
        params.each_pair do |config,value|
          should contain_cinder_config(
            "#{config_group_name}/#{config}").with_value(value)
        end
      }

      it { should contain_cinder_config('solidfire/san_password').with_secret(true) }
    end

    context 'SolidFire backend driver with all params' do
      let :params do
        req_params.merge(other_params)
      end

      it { should contain_cinder__backend__solidfire(config_group_name) }
      it { should contain_cinder_config("#{config_group_name}/volume_driver").with(
        :value => 'cinder.volume.drivers.solidfire.SolidFireDriver'
      )}

      it {
        params.each_pair do |config,value|
          should contain_cinder_config(
            "#{config_group_name}/#{config}").with_value(value)
        end
      }

      it { should contain_cinder_config('solidfire/san_password').with_secret(true) }
    end

    context 'solidfire backend with additional configuration' do
      let :params do
        req_params
      end

      before :each do
        params.merge!( :extra_options => {'solidfire/param1' => {'value' => 'value1'}} )
      end

      it { should contain_cinder_config('solidfire/param1').with_value('value1') }
    end

    context 'solidfire backend with cinder type' do
      let :params do
        req_params
      end

      before :each do
        params.merge!( :manage_volume_type => true )
      end

      it { should contain_cinder_type('solidfire').with(
        :ensure     => 'present',
        :properties => ['volume_backend_name=solidfire']
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

      it_behaves_like 'cinder::backend::solidfire'
    end
  end
end
