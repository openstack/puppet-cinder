require 'spec_helper'

describe 'cinder::backend::dellemc_xtremio_iscsi' do

  let (:config_group_name) { 'dellemc_xtremio_iscsi' }

  let (:title) { config_group_name }

  let :params do
    {
      :san_ip                => '172.23.8.101',
      :san_login             => 'Admin',
      :san_password          => '12345',
      :xtremio_cluster_name  => 'Cluster01',
    }
  end

  let :default_params do
    {
      :xtremio_array_busy_retry_count    => 5,
      :xtremio_array_busy_retry_interval => 5,
      :xtremio_volumes_per_glance_cache  => 100,
    }
  end

  let :facts do
    OSDefaults.get_facts({})
  end

  shared_examples_for 'dellemc_xtremio_iscsi volume driver' do
    let :params_hash do
      default_params.merge(params)
    end

    it 'configures cinder volume driver' do
      is_expected.to contain_cinder__backend__dellemc_xtremio_iscsi(config_group_name)
      is_expected.to contain_cinder_config("#{title}/volume_driver").with_value(
            'cinder.volume.drivers.emc.xtremio.XtremIOISCSIDriver')
      params_hash.each_pair do |config,value|
        is_expected.to contain_cinder_config("#{config_group_name}/#{config}").with_value( value )
      end
    end
  end


  context 'with parameters' do
    it_configures 'dellemc_xtremio_iscsi volume driver'
  end

  context 'dellemc_xtremio_iscsi backend with additional configuration' do
    before do
      params.merge!({:extra_options => {'dellemc_xtremio_iscsi/param1' => { 'value' => 'value1' }}})
    end

    it 'configure dellemc_xtremio_iscsi backend with additional configuration' do
      is_expected.to contain_cinder_config('dellemc_xtremio_iscsi/param1').with({
        :value => 'value1'
      })
    end
  end

  context 'dellemc_xtremio_iscsi backend with cinder type' do
    before do
      params.merge!({:manage_volume_type => true})
    end
    it 'should create type with properties' do
      should contain_cinder_type('dellemc_xtremio_iscsi').with(:ensure => :present, :properties => ['volume_backend_name=dellemc_xtremio_iscsi'])
    end
  end

end
