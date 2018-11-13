require 'spec_helper'

describe 'cinder::backend::emc_vnx' do
  let (:title) { 'emc' }

  let :req_params do
    {
      :san_ip                   => '127.0.0.2',
      :san_login                => 'emc',
      :san_password             => 'password',
      :storage_vnx_pool_names   => 'emc-storage-pool'
    }
  end

  let :params do
    req_params
  end

  shared_examples 'cinder::backend::emc_vnx' do
    context 'emc vnx volume driver' do
      it {
        should contain_cinder_config('emc/volume_driver').with_value('cinder.volume.drivers.dell_emc.vnx.driver.VNXDriver')
        should contain_cinder_config('emc/storage_protocol').with_value('iscsi')
        should contain_cinder_config('emc/san_ip').with_value('127.0.0.2')
        should contain_cinder_config('emc/san_login').with_value('emc')
        should contain_cinder_config('emc/san_password').with_value('password').with_secret(true)
        should contain_cinder_config('emc/storage_vnx_pool_names').with_value('emc-storage-pool')
        should contain_cinder_config('emc/initiator_auto_registration').with_value('<SERVICE DEFAULT>')
        should contain_cinder_config('emc/storage_vnx_authentication_type').with_value('<SERVICE DEFAULT>')
        should contain_cinder_config('emc/storage_vnx_security_file_dir').with_value('<SERVICE DEFAULT>')
        should contain_cinder_config('emc/naviseccli_path').with_value('<SERVICE DEFAULT>')
        should contain_cinder_config('emc/backend_availability_zone').with_value('<SERVICE DEFAULT>')
      }
    end

    context 'emc vnx backend overriding some parameters' do
      before :each do
        params.merge!({
          :initiator_auto_registration   => true,
          :storage_vnx_auth_type         => 'global',
          :storage_vnx_security_file_dir => '/etc/secfile/array1',
          :naviseccli_path               => '/opt/Navisphere/bin/naviseccli',
          :manage_volume_type            => true,
          :storage_protocol              => 'fc',
          :backend_availability_zone     => 'my_zone',
        })
      end

      it {
        should contain_cinder_config('emc/initiator_auto_registration').with_value(params[:initiator_auto_registration])
        should contain_cinder_config('emc/storage_vnx_authentication_type').with_value(params[:storage_vnx_auth_type])
        should contain_cinder_config('emc/storage_vnx_security_file_dir').with_value(params[:storage_vnx_security_file_dir])
        should contain_cinder_config('emc/naviseccli_path').with_value(params[:naviseccli_path])
        should contain_cinder_config('emc/storage_protocol').with_value(params[:storage_protocol])
        should contain_cinder_config('emc/backend_availability_zone').with_value(params[:backend_availability_zone])
      }

      it { should contain_cinder_type('emc').with(
        :ensure     => 'present',
        :properties => ['volume_backend_name=emc']
      )}
    end

    context 'emc vnx backend with additional configuration' do
      before :each do
        params.merge!( :extra_options => {'emc/param1' => {'value' => 'value1'}} )
      end

      it { should contain_cinder_config('emc/param1').with_value('value1') }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder::backend::emc_vnx'
    end
  end
end
