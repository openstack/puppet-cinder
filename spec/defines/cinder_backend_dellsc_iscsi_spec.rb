require 'spec_helper'

describe 'cinder::backend::dellsc_iscsi' do

  let (:config_group_name) { 'dellsc_iscsi' }

  let (:title) { config_group_name }

  let :params do
    {
      :san_ip                => '172.23.8.101',
      :san_login             => 'Admin',
      :san_password          => '12345',
      :iscsi_ip_address      => '192.168.0.20',
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
      :iscsi_port                   => '<SERVICE DEFAULT>',
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
      :iscsi_port                => 222,
      :excluded_domain_ip        => '127.0.0.2',
      :secondary_san_ip          => '127.0.0.3',
      :secondary_san_login       => 'Foo',
      :secondary_san_password    => 'Bar',
      :secondary_sc_api_port     => 333,
    }
  end

  let :facts do
    OSDefaults.get_facts({})
  end

  shared_examples_for 'dellsc_iscsi volume driver' do
    let :params_hash do
      default_params.merge(params)
    end

    it 'configures cinder volume driver' do
      is_expected.to contain_cinder__backend__dellsc_iscsi(config_group_name)
      params_hash.each_pair do |config,value|
        is_expected.to contain_cinder_config("#{config_group_name}/#{config}").with_value( value )
      end
      is_expected.to contain_cinder_config("#{config_group_name}/volume_driver").with_value(
        'cinder.volume.drivers.dell_emc.sc.storagecenter_iscsi.SCISCSIDriver')
      is_expected.to contain_cinder_config("#{config_group_name}/use_multipath_for_image_xfer").with_value('true')
    end
  end


  context 'with default parameters' do
    it_configures 'dellsc_iscsi volume driver'
  end

  context 'with custom parameters' do
    before do
      params.merge(custom_params)
    end
    it_configures 'dellsc_iscsi volume driver'
  end

  context 'dellsc_iscsi backend with additional configuration' do
    before do
      params.merge!({:extra_options => {'dellsc_iscsi/param1' => { 'value' => 'value1' }}})
    end

    it 'configure dellsc_iscsi backend with additional configuration' do
      is_expected.to contain_cinder_config('dellsc_iscsi/param1').with({
        :value => 'value1'
      })
    end
  end

  context 'dellsc_iscsi backend with cinder type' do
    before do
      params.merge!({:manage_volume_type => true})
    end
    it 'should create type with properties' do
      should contain_cinder_type('dellsc_iscsi').with(:ensure => :present, :properties => ['volume_backend_name=dellsc_iscsi'])
    end
  end

end
