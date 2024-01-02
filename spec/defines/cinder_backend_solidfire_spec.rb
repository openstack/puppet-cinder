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

  let :default_params do
    {
      :backend_availability_zone      => '<SERVICE DEFAULT>',
      :image_volume_cache_enabled     => '<SERVICE DEFAULT>',
      :image_volume_cache_max_size_gb => '<SERVICE DEFAULT>',
      :image_volume_cache_max_count   => '<SERVICE DEFAULT>',
      :reserved_percentage            => '<SERVICE DEFAULT>',
      :sf_emulate_512                 => '<SERVICE DEFAULT>',
      :sf_allow_tenant_qos            => '<SERVICE DEFAULT>',
      :sf_account_prefix              => '<SERVICE DEFAULT>',
      :sf_api_port                    => '<SERVICE DEFAULT>',
      :sf_volume_prefix               => '<SERVICE DEFAULT>',
      :sf_svip                        => '<SERVICE DEFAULT>',
      :sf_enable_vag                  => '<SERVICE DEFAULT>',
      :sf_provisioning_calc           => '<SERVICE DEFAULT>',
      :sf_cluster_pairing_timeout     => '<SERVICE DEFAULT>',
      :sf_volume_pairing_timeout      => '<SERVICE DEFAULT>',
      :sf_api_request_timeout         => '<SERVICE DEFAULT>',
      :sf_volume_clone_timeout        => '<SERVICE DEFAULT>',
      :sf_volume_create_timeout       => '<SERVICE DEFAULT>',
    }
  end

  let :other_params do
    {
      :backend_availability_zone      => 'az1',
      :image_volume_cache_enabled     => true,
      :image_volume_cache_max_size_gb => 100,
      :image_volume_cache_max_count   => 101,
      :reserved_percentage            => 10,
      :sf_emulate_512                 => true,
      :sf_allow_tenant_qos            => false,
      :sf_account_prefix              => 'acc_prefix',
      :sf_api_port                    => 443,
      :sf_volume_prefix               => 'UUID-',
      :sf_svip                        => 'svip',
      :sf_enable_vag                  => false,
      :sf_provisioning_calc           => 'maxProvisionedSpace',
      :sf_cluster_pairing_timeout     => 60,
      :sf_volume_pairing_timeout      => 3600,
      :sf_api_request_timeout         => 30,
      :sf_volume_clone_timeout        => 600,
      :sf_volume_create_timeout       => 60,
    }
  end

  shared_examples 'a solidfire volume driver' do
    let :params_hash do
      default_params.merge(params)
    end
 
    it {
      is_expected.to contain_cinder_config("#{config_group_name}/volume_driver").with(
        :value => 'cinder.volume.drivers.solidfire.SolidFireDriver'
      )

      params_hash.each_pair do |config,value|
        is_expected.to contain_cinder_config("#{config_group_name}/#{config}").with_value(value)
      end

      is_expected.to contain_cinder_config("#{config_group_name}/san_password").with_secret(true)
    }
  end

  shared_examples 'cinder::backend::solidfire' do
    context 'with minimal params' do
      let :params do
        req_params
      end

      it_behaves_like 'a solidfire volume driver'
    end

    context 'with all params' do
      let :params do
        req_params.merge(other_params)
      end

      it_behaves_like 'a solidfire volume driver'
    end

    context 'with extra options' do
      let :params do
        req_params.merge({
          :extra_options => {
            'solidfire/param1' => {'value' => 'value1'}
          }
        })
      end

      it { is_expected.to contain_cinder_config('solidfire/param1').with_value('value1') }
    end

    context 'with cinder type management enabled' do
      let :params do
        req_params.merge( :manage_volume_type => true )
      end

      it { is_expected.to contain_cinder_type('solidfire').with(
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
