require 'spec_helper'

describe 'cinder::backend::dellemc_unity' do

  let (:config_group_name) { 'dellemc_unity' }

  let (:title) { config_group_name }

  let :params do
    {
      :san_ip                => '172.23.8.101',
      :san_login             => 'Admin',
      :san_password          => '12345',
      :storage_protocol      => 'iSCSI',
    }
  end

  let :default_params do
    {
      :unity_io_ports            => '<SERVICE DEFAULT>',
      :unity_storage_pool_names  => '<SERVICE DEFAULT>',
    }
  end

  let :facts do
    OSDefaults.get_facts({})
  end

  shared_examples_for 'dellemc_unity volume driver' do
    let :params_hash do
      default_params.merge(params)
    end

    it 'configures cinder volume driver' do
      is_expected.to contain_cinder__backend__dellemc_unity(config_group_name)
      is_expected.to contain_cinder_config("#{title}/volume_driver").with_value(
            'cinder.volume.drivers.dell_emc.unity.Driver')
      params_hash.each_pair do |config,value|
        is_expected.to contain_cinder_config("#{config_group_name}/#{config}").with_value( value )
      end
    end
  end


  context 'with parameters' do
    it_configures 'dellemc_unity volume driver'
  end

  context 'dellemc_unity backend with additional configuration' do
    before do
      params.merge!({:extra_options => {'dellemc_unity/param1' => { 'value' => 'value1' }}})
    end

    it 'configure dellemc_unity backend with additional configuration' do
      is_expected.to contain_cinder_config('dellemc_unity/param1').with({
        :value => 'value1'
      })
    end
  end

  context 'dellemc_unity backend with cinder type' do
    before do
      params.merge!({:manage_volume_type => true})
    end
    it 'should create type with properties' do
      should contain_cinder_type('dellemc_unity').with(:ensure => :present, :properties => ['volume_backend_name=dellemc_unity'])
    end
  end

end
