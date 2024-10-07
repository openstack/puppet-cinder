require 'spec_helper'

describe 'cinder::backend::san' do
  let (:title) { 'mysan' }

  let :params do
    {
      :volume_driver => 'cinder.volume.san.SolarisISCSIDriver',
    }
  end

  let :default_params do
    {
      :backend_availability_zone      => '<SERVICE DEFAULT>',
      :image_volume_cache_enabled     => '<SERVICE DEFAULT>',
      :image_volume_cache_max_size_gb => '<SERVICE DEFAULT>',
      :image_volume_cache_max_count   => '<SERVICE DEFAULT>',
      :san_thin_provision             => '<SERVICE DEFAULT>',
      :san_ip                         => '<SERVICE DEFAULT>',
      :san_login                      => '<SERVICE DEFAULT>',
      :san_password                   => '<SERVICE DEFAULT>',
      :san_private_key                => '<SERVICE DEFAULT>',
      :san_clustername                => '<SERVICE DEFAULT>',
      :san_ssh_port                   => '<SERVICE DEFAULT>',
      :san_api_port                   => '<SERVICE DEFAULT>',
      :san_is_local                   => '<SERVICE DEFAULT>',
      :ssh_conn_timeout               => '<SERVICE DEFAULT>',
      :ssh_min_pool_conn              => '<SERVICE DEFAULT>',
      :ssh_max_pool_conn              => '<SERVICE DEFAULT>',
    }
  end

  shared_examples 'a san volume driver' do
    let :params_hash do
      default_params.merge(params)
    end

    it {
      params_hash.each_pair do |config,value|
        is_expected.to contain_cinder_config("mysan/#{config}").with_value(value)
      end

      is_expected.to contain_cinder_config('mysan/san_password').with_secret(true)
    }
  end

  shared_examples 'cinder::backend::san' do
    context 'with defaults' do
      it_behaves_like 'a san volume driver'
    end

    context 'with parameters' do
      before do
        params.merge!({
          :backend_availability_zone => 'my_zone',
          :san_thin_provision        => true,
          :san_ip                    => '127.0.0.1',
          :san_login                 => 'admin',
          :san_password              => 'secret',
          :san_clustername           => 'storage_cluster',
          :san_ssh_port              => 22,
          :san_api_port              => 8080,
          :san_is_local              => false,
          :ssh_conn_timeout          => 30,
          :ssh_min_pool_conn         => 1,
          :ssh_max_pool_conn         => 5,
        })
      end

      it_behaves_like 'a san volume driver'
    end

    context 'san backend with additional configuration' do
      before do
        params.merge!( :extra_options => {'mysan/param1' => { 'value' => 'value1' }} )
      end

      it { is_expected.to contain_cinder_config('mysan/param1').with_value('value1') }
    end

    context 'san backend with cinder type' do
      before do
        params.merge!( :manage_volume_type => true )
      end

      it { is_expected.to contain_cinder_type('mysan').with(
        :ensure     => 'present',
        :properties => {'volume_backend_name' => 'mysan'}
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

      it_behaves_like 'cinder::backend::san'
    end
  end
end
