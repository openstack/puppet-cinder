require 'spec_helper'

describe 'cinder::backend::dellemc_xtremio' do
  let (:config_group_name) { 'dellemc_xtremio' }

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

  shared_examples 'dellemc_xtremio volume driver' do
    let :params_hash do
      default_params.merge(params)
    end

    it {
      is_expected.to contain_cinder__backend__dellemc_xtremio(config_group_name)
      is_expected.to contain_cinder_config("#{title}/volume_driver").with_value('cinder.volume.drivers.dell_emc.xtremio.XtremIOISCSIDriver')
    }

    it {
      params_hash.each_pair do |config,value|
        is_expected.to contain_cinder_config("#{config_group_name}/#{config}").with_value( value )
      end
    }
  end

   context 'with xtremio_storage_protocol set to FC' do
      before do
        params.merge!(:xtremio_storage_protocol => 'FC',)
      end

      it 'should configure the FC driver' do
        is_expected.to contain_cinder_config("#{title}/volume_driver").with_value(
          'cinder.volume.drivers.dell_emc.xtremio.XtremIOFCDriver'
        )
      end
    end

    context 'with an invalid xtremio_storage_protocol' do
      before do
        params.merge!(:xtremio_storage_protocol => 'BAD',)
      end

      it 'should raise an error' do
        is_expected.to compile.and_raise_error(
          /The cinder::backend::dellemc_xtremio xtremio_storage_protocol specified is not valid. It should be iSCSI or FC/
        )
      end
    end

  shared_examples 'cinder::backend::dellemc_xtremio' do
    context 'with default parameters' do
      it_behaves_like 'dellemc_xtremio volume driver'
    end

    context 'with custom parameters' do
      before do
        params.merge(custom_params)
      end

      it_behaves_like 'dellemc_xtremio volume driver'
    end

    context 'dellemc_xtremio backend with additional configuration' do
      before do
        params.merge!( :extra_options => {'dellemc_xtremio/param1' => { 'value' => 'value1' }} )
      end

      it { is_expected.to contain_cinder_config('dellemc_xtremio/param1').with_value('value1') }
    end

    context 'dellemc_xtremio backend with cinder type' do
      before do
        params.merge!({:manage_volume_type => true})
      end

      it { is_expected.to contain_cinder_type('dellemc_xtremio').with(
        :ensure => 'present',
        :properties => ['volume_backend_name=dellemc_xtremio']
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

      it_behaves_like 'cinder::backend::dellemc_xtremio'
    end
  end
end
