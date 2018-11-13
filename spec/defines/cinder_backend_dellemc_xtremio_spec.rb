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
      :backend_availability_zone         => '<SERVICE DEFAULT>',
      :xtremio_array_busy_retry_count    => 5,
      :xtremio_array_busy_retry_interval => 5,
      :xtremio_volumes_per_glance_cache  => 100,
    }
  end

  let :custom_params do
    {
      :backend_availability_zone         => 'my_zone',
      :xtremio_array_busy_retry_count    => 15,
      :xtremio_array_busy_retry_interval => 25,
      :xtremio_volumes_per_glance_cache  => 10,
    }
  end

  shared_examples 'dellemc_xtremio_iscsi volume driver' do
    let :params_hash do
      default_params.merge(params)
    end

    it {
      should contain_cinder__backend__dellemc_xtremio_iscsi(config_group_name)
      should contain_cinder_config("#{title}/volume_driver").with_value('cinder.volume.drivers.dell_emc.xtremio.XtremIOISCSIDriver')
    }

    it {
      params_hash.each_pair do |config,value|
        should contain_cinder_config("#{config_group_name}/#{config}").with_value( value )
      end
    }
  end

  shared_examples 'cinder::backend::dellemc_xtremio_iscsi' do
    context 'with default parameters' do
      it_behaves_like 'dellemc_xtremio_iscsi volume driver'
    end

    context 'with custom parameters' do
      before do
        params.merge(custom_params)
      end

      it_behaves_like 'dellemc_xtremio_iscsi volume driver'
    end

    context 'dellemc_xtremio_iscsi backend with additional configuration' do
      before do
        params.merge!( :extra_options => {'dellemc_xtremio_iscsi/param1' => { 'value' => 'value1' }} )
      end

      it { should contain_cinder_config('dellemc_xtremio_iscsi/param1').with_value('value1') }
    end

    context 'dellemc_xtremio_iscsi backend with cinder type' do
      before do
        params.merge!({:manage_volume_type => true})
      end

      it { should contain_cinder_type('dellemc_xtremio_iscsi').with(
        :ensure => 'present',
        :properties => ['volume_backend_name=dellemc_xtremio_iscsi']
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

      it_behaves_like 'cinder::backend::dellemc_xtremio_iscsi'
    end
  end
end
