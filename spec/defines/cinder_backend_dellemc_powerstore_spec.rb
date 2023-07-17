require 'spec_helper'

describe 'cinder::backend::dellemc_powerstore' do
  let (:config_group_name) { 'dellemc_powerstore' }

  let (:title) { config_group_name }

  let :params do
    {
      :san_ip                => '172.23.8.101',
      :san_login             => 'Admin',
      :san_password          => '12345',
    }
  end

  let :default_params do
    {
      :powerstore_ports          => '<SERVICE DEFAULT>',
      :backend_availability_zone => '<SERVICE DEFAULT>',
      :storage_protocol          => 'iSCSI' ,
    }
  end

  let :custom_params do
    {
      :powerstore_ports          => '58:cc:f0:98:49:22:07:02,58:cc:f0:98:49:23:07:02',
      :backend_availability_zone => 'my_zone',
      :storage_protocol          => 'iSCSI' ,
    }
  end

  shared_examples 'dellemc_powerstore volume driver' do

    context 'with default parameters' do
      let :params_hash do
        default_params.merge(params)
      end

      it {
        is_expected.to contain_cinder__backend__dellemc_powerstore(config_group_name)
        is_expected.to contain_cinder_config("#{title}/volume_driver").with_value('cinder.volume.drivers.dell_emc.powerstore.driver.PowerStoreDriver')
      }

      it {
        params_hash.each_pair do |config,value|
          is_expected.to contain_cinder_config("#{config_group_name}/#{config}").with_value( value )
        end
      }
    end

    context 'with storage_protocol set to FC' do
      before do
        params.merge!(:storage_protocol => 'FC',)
      end

      it 'should configure the FC driver' do
        is_expected.to contain_cinder_config("#{title}/volume_driver").with_value(
          'cinder.volume.drivers.dell_emc.powerstore.driver.PowerStoreDriver'
        )
      end
    end

    context 'with an invalid storage_protocol' do
      before do
        params.merge!(:storage_protocol => 'BAD',)
      end

      it 'should raise an error' do
        is_expected.to compile.and_raise_error(/Evaluation Error/)
      end
    end
  end

  shared_examples 'cinder::backend::dellemc_powerstore' do

    context 'with default parameters' do
      it_behaves_like 'dellemc_powerstore volume driver'
    end

    context 'with custom parameters' do
      before do
        params.merge(custom_params)
      end

      it_behaves_like 'dellemc_powerstore volume driver'
    end

    context 'dellemc_powerstore backend with additional configuration' do
      before do
        params.merge!( :extra_options => {'dellemc_powerstore/param1' => { 'value' => 'value1' }} )
      end

      it { is_expected.to contain_cinder_config('dellemc_powerstore/param1').with_value('value1') }
    end

    context 'dellemc_powerstore backend with cinder type' do
      before do
        params.merge!({:manage_volume_type => true})
      end

      it { is_expected.to contain_cinder_type('dellemc_powerstore').with(
        :ensure => 'present',
        :properties => ['volume_backend_name=dellemc_powerstore']
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

      it_behaves_like 'cinder::backend::dellemc_powerstore'
    end
  end
end
