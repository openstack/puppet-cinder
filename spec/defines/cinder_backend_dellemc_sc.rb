require 'spec_helper'

describe 'cinder::backend::dellemc_sc' do
  let (:config_group_name) { 'dellemc_sc' }

  let (:title) { config_group_name }

  let :params do
    {
      :san_ip                => '172.23.8.101',
      :san_login             => 'Admin',
      :san_password          => '12345',
      :target_ip_address     => '192.168.0.20',
      :dell_sc_ssn           => '64720',
    }
  end

  let :default_params do
    {
      :backend_availability_zone    => '<SERVICE DEFAULT>',
      :dell_sc_api_port             => '<SERVICE DEFAULT>',
      :dell_sc_server_folder        => 'srv',
      :dell_sc_verify_cert          => '<SERVICE DEFAULT>',
      :dell_sc_volume_folder        => 'vol',
      :target_port                  => '<SERVICE DEFAULT>',
      :excluded_domain_ips          => '<SERVICE DEFAULT>',
      :secondary_san_ip             => '<SERVICE DEFAULT>',
      :secondary_san_login          => '<SERVICE DEFAULT>',
      :secondary_san_password       => '<SERVICE DEFAULT>',
      :secondary_sc_api_port        => '<SERVICE DEFAULT>',
      :use_multipath_for_image_xfer => 'true',
    }
  end

  let :custom_params do
    {
      :backend_availability_zone => 'my_zone',
      :dell_sc_api_port          => 111,
      :dell_sc_server_folder     => 'other_srv',
      :dell_sc_verify_cert       => true,
      :dell_sc_volume_folder     => 'other_vol',
      :target_port               => 222,
      :secondary_san_ip          => '127.0.0.3',
      :secondary_san_login       => 'Foo',
      :secondary_san_password    => 'Bar',
      :secondary_sc_api_port     => 333,
    }
  end

  shared_examples 'dellemc_sc volume driver' do
    let :params_hash do
      default_params.merge(params)
    end

    it { is_expected.to contain_cinder__backend__dellemc_sc(config_group_name) }

    it {
      params_hash.each_pair do |config,value|
        is_expected.to contain_cinder_config("#{config_group_name}/#{config}").with_value( value )
      end
    }

    it {
      is_expected.to contain_cinder_config("#{config_group_name}/volume_driver").with_value('cinder.volume.drivers.dell_emc.sc.storagecenter_iscsi.SCISCSIDriver')
      is_expected.to contain_cinder_config("#{config_group_name}/use_multipath_for_image_xfer").with_value('true')
    }
  end

   context 'with sc_storage_protocol set to FC' do
      before do
        params.merge!(:sc_storage_protocol => 'FC',)
      end

      it 'should configure the FC driver' do
        is_expected.to contain_cinder_config("#{title}/volume_driver").with_value(
          'cinder.volume.drivers.dell_emc.sc.storagecenter_fc.SCFCDriver'
        )
      end
    end

    context 'with an invalid sc_storage_protocol' do
      before do
        params.merge!(:sc_storage_protocol => 'BAD',)
      end

      it 'should raise an error' do
        is_expected.to compile.and_raise_error(
          /The cinder::backend::dellemc_sc sc_storage_protocol specified is not valid. It should be iSCSI or FC/
        )
      end
    end

  shared_examples 'cinder::backend::dellemc_sc' do
    context 'with default parameters' do
      it_behaves_like 'dellemc_sc volume driver'
    end

    context 'with custom parameters' do
      before do
        params.merge(custom_params)
      end

      it_behaves_like 'dellemc_sc volume driver'
    end

    context 'dellemc_sc backend with additional configuration' do
      before do
        params.merge!({:extra_options => {'dellemc_sc/param1' => { 'value' => 'value1' }}})
      end

      it { is_expected.to contain_cinder_config('dellemc_sc/param1').with_value('value1') }
    end

    context 'dellemc_sc backend with cinder type' do
      before do
        params.merge!({:manage_volume_type => true})
      end

      it { is_expected.to contain_cinder_type('dellemc_sc').with(:ensure => :present, :properties => ['volume_backend_name=dellemc_sc']) }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder::backend::dellemc_sc'
    end
  end
end
