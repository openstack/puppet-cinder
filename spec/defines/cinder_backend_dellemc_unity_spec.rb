require 'spec_helper'

describe 'cinder::backend::dellemc_unity' do
  let (:config_group_name) { 'dellemc_unity' }

  let (:title) { config_group_name }

  let :params do
    {
      :san_ip           => '172.23.8.101',
      :san_login        => 'Admin',
      :san_password     => '12345',
      :storage_protocol => 'iSCSI',
    }
  end

  let :default_params do
    {
      :backend_availability_zone => '<SERVICE DEFAULT>',
      :unity_io_ports            => '<SERVICE DEFAULT>',
      :unity_storage_pool_names  => '<SERVICE DEFAULT>',
    }
  end

  let :custom_params do
    {
      :backend_availability_zone => 'my_zone',
      :unity_io_ports            => '1,42,66',
      :unity_storage_pool_names  => 'pool_1,pool_2',
    }
  end

  shared_examples 'dellemc_unity volume driver' do
    let :params_hash do
      default_params.merge(params)
    end

    it { is_expected.to contain_cinder__backend__dellemc_unity(config_group_name) }
    it { is_expected.to contain_cinder_config("#{title}/volume_driver").with(
      :value => 'cinder.volume.drivers.dell_emc.unity.Driver'
    )}

    it {
      params_hash.each_pair do |config,value|
        is_expected.to contain_cinder_config("#{config_group_name}/#{config}").with_value(value)
      end
    }
  end

  shared_examples 'cinder::backend::dellemc_unity' do
    context 'with default parameters' do
      it_behaves_like 'dellemc_unity volume driver'
    end

    context 'with custom parameters' do
      before do
        params.merge(custom_params)
      end

      it_behaves_like 'dellemc_unity volume driver'
    end

    context 'with array values' do
      before do
        params.merge!({
          :unity_io_ports            => ['1', '42', '66'],
          :unity_storage_pool_names  => ['pool_1', 'pool_2'],
        })
      end

      it {
        is_expected.to contain_cinder_config('dellemc_unity/unity_io_ports').with_value('1,42,66')
        is_expected.to contain_cinder_config('dellemc_unity/unity_storage_pool_names').with_value('pool_1,pool_2')
      }
    end

    context 'dellemc_unity backend with additional configuration' do
      before do
        params.merge!( :extra_options => {'dellemc_unity/param1' => { 'value' => 'value1' }} )
      end

      it { is_expected.to contain_cinder_config('dellemc_unity/param1').with_value('value1') }
    end

    context 'dellemc_unity backend with cinder type' do
      before do
        params.merge!( :manage_volume_type => true )
      end

      it { is_expected.to contain_cinder_type('dellemc_unity').with(
        :ensure     => 'present',
        :properties => ['volume_backend_name=dellemc_unity']
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

      it_behaves_like 'cinder::backend::dellemc_unity'
    end
  end
end
