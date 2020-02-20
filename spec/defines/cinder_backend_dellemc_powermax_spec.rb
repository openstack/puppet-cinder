require 'spec_helper'

describe 'cinder::backend::dellemc_powermax' do
  let (:config_group_name) { 'dellemc_powermax' }

  let (:title) { config_group_name }

  let :params do
    {
      :san_ip                    => '127.0.0.2',
      :san_login                 => 'Admin',
      :san_password              => '12345',
      :powermax_array            => '000123456789',
      :powermax_srp              => 'SRP_1',
      :powermax_port_groups      => '[OS-ISCSI-PG]',
    }
  end

  shared_examples 'cinder::backend::dellemc_powermax' do
    context 'with default parameters' do
      it 'should configure an iSCSI dellemc_powermax backend' do
        is_expected.to contain_cinder__backend__dellemc_powermax(config_group_name)
        is_expected.to contain_cinder_config("#{title}/volume_driver").with_value(
          'cinder.volume.drivers.dell_emc.powermax.iscsi.PowerMaxISCSIDriver'
        )
        is_expected.to contain_cinder_config("#{title}/san_ip").with_value('127.0.0.2')
        is_expected.to contain_cinder_config("#{title}/san_login").with_value('Admin')
        is_expected.to contain_cinder_config("#{title}/san_password").with_value('12345')
        is_expected.to contain_cinder_config("#{title}/powermax_array").with_value('000123456789')
        is_expected.to contain_cinder_config("#{title}/powermax_srp").with_value('SRP_1')
        is_expected.to contain_cinder_config("#{title}/powermax_port_groups").with_value('[OS-ISCSI-PG]')
        is_expected.to contain_cinder_config("#{title}/backend_availability_zone").with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with powermax_storage_protocol set to FC' do
      before do
        params.merge!(:powermax_storage_protocol => 'FC',)
      end

      it 'should configure the FC driver' do
        is_expected.to contain_cinder_config("#{title}/volume_driver").with_value(
          'cinder.volume.drivers.dell_emc.powermax.fc.PowerMaxFCDriver'
        )
      end
    end

    context 'with an invalid powermax_storage_protocol' do
      before do
        params.merge!(:powermax_storage_protocol => 'BAD',)
      end

      it 'should raise an error' do
        is_expected.to compile.and_raise_error(
          /The cinder::backend::dellemc_powermax powermax_storage_protocol specified is not valid. It should be iSCSI or FC/
        )
      end
    end

    context 'with custom backend_availability_zone' do
      before do
        params.merge!(:backend_availability_zone => 'my_zone')
      end

      it 'should configure the backend_availability_zone' do
        is_expected.to contain_cinder_config("#{title}/backend_availability_zone").with_value('my_zone')
      end
    end

    context 'dellemc_powermax backend with additional configuration' do
      before do
        params.merge!( :extra_options => {'dellemc_powermax/param1' => { 'value' => 'value1' }} )
      end

      it { is_expected.to contain_cinder_config('dellemc_powermax/param1').with_value('value1') }
    end

    context 'dellemc_powermax backend with cinder type' do
      before do
        params.merge!( :manage_volume_type => true )
      end

      it { is_expected.to contain_cinder_type('dellemc_powermax').with(
        :ensure     => 'present',
        :properties => ['volume_backend_name=dellemc_powermax']
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

      it_behaves_like 'cinder::backend::dellemc_powermax'
    end
  end
end
