require 'spec_helper'

describe 'cinder::backend::emc_vnx' do
  let (:title) { 'emc' }

  let :req_params do
    {
      :san_ip                => '127.0.0.2',
      :san_login             => 'emc',
      :san_password          => 'password',
      :iscsi_ip_address      => '127.0.0.3',
      :storage_vnx_pool_name => 'emc-storage-pool'
    }
  end

  let :facts do
    OSDefaults.get_facts({:osfamily => 'Redhat' })
  end

  let :params do
    req_params
  end

  describe 'emc vnx volume driver' do
    it 'configure emc vnx volume driver' do
      is_expected.to contain_cinder_config('emc/volume_driver').with_value('cinder.volume.drivers.emc.emc_cli_iscsi.EMCCLIISCSIDriver')
      is_expected.to contain_cinder_config('emc/san_ip').with_value('127.0.0.2')
      is_expected.to contain_cinder_config('emc/san_login').with_value('emc')
      is_expected.to contain_cinder_config('emc/san_password').with_value('password')
      is_expected.to contain_cinder_config('emc/iscsi_ip_address').with_value('127.0.0.3')
      is_expected.to contain_cinder_config('emc/storage_vnx_pool_name').with_value('emc-storage-pool')
      is_expected.to contain_cinder_config('emc/initiator_auto_registration').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('emc/storage_vnx_authentication_type').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('emc/storage_vnx_security_file_dir').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('emc/naviseccli_path').with_value('<SERVICE DEFAULT>')

    end
  end

  describe 'emc vnx backend overriding some parameters' do
    before :each do
      params.merge!({
       :initiator_auto_registration   => true,
       :storage_vnx_auth_type         => 'global',
       :storage_vnx_security_file_dir => '/etc/secfile/array1',
       :naviseccli_path               => '/opt/Navisphere/bin/naviseccli',
      })
    end

    it 'configure emc vnx volume driver' do
      is_expected.to contain_cinder_config('emc/initiator_auto_registration').with_value(params[:initiator_auto_registration])
      is_expected.to contain_cinder_config('emc/storage_vnx_authentication_type').with_value(params[:storage_vnx_auth_type])
      is_expected.to contain_cinder_config('emc/storage_vnx_security_file_dir').with_value(params[:storage_vnx_security_file_dir])
      is_expected.to contain_cinder_config('emc/naviseccli_path').with_value(params[:naviseccli_path])
    end
  end

  describe 'emc vnx backend with additional configuration' do
    before :each do
      params.merge!({:extra_options => {'emc/param1' => {'value' => 'value1'}}})
    end

    it 'configure emc vnx backend with additional configuration' do
      is_expected.to contain_cinder_config('emc/param1').with({
        :value => 'value1',
      })
    end
  end

end
