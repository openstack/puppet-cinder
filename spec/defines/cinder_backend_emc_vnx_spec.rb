require 'spec_helper'

describe 'cinder::backend::emc_vnx' do
  let (:title) { 'emc' }

  let :req_params do
    {
      :san_ip                => '127.0.0.2',
      :san_login             => 'emc',
      :san_password          => 'password',
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
      is_expected.to contain_cinder_config('emc/volume_driver').with_value('cinder.volume.drivers.emc.vnx.driver.EMCVNXDriver')
      is_expected.to contain_cinder_config('emc/storage_protocol').with_value('iscsi')
      is_expected.to contain_cinder_config('emc/san_ip').with_value('127.0.0.2')
      is_expected.to contain_cinder_config('emc/san_login').with_value('emc')
      is_expected.to contain_cinder_config('emc/san_password').with_value('password')
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
       :manage_volume_type            => true,
       :storage_protocol              => 'fc',
      })
    end

    it 'configure emc vnx volume driver' do
      is_expected.to contain_cinder_config('emc/initiator_auto_registration').with_value(params[:initiator_auto_registration])
      is_expected.to contain_cinder_config('emc/storage_vnx_authentication_type').with_value(params[:storage_vnx_auth_type])
      is_expected.to contain_cinder_config('emc/storage_vnx_security_file_dir').with_value(params[:storage_vnx_security_file_dir])
      is_expected.to contain_cinder_config('emc/naviseccli_path').with_value(params[:naviseccli_path])
      is_expected.to contain_cinder_config('emc/storage_protocol').with_value(params[:storage_protocol])
    end

    it 'should create type with properties' do
      should contain_cinder_type('emc').with(:ensure => :present, :properties => ['volume_backend_name=emc'])
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
