require 'spec_helper'

describe 'cinder::backend::san' do
  let (:title) { 'mysan' }

  let :params do
    {
      :backend_availability_zone => 'my_zone',
      :volume_driver             => 'cinder.volume.san.SolarisISCSIDriver',
      :san_ip                    => '127.0.0.1',
      :san_login                 => 'cluster_operator',
      :san_password              => '007',
      :san_clustername           => 'storage_cluster',
    }
  end

  let :default_params do
    {
      :san_thin_provision => true,
      :san_login          => 'admin',
      :san_ssh_port       => 22,
      :san_is_local       => false,
      :ssh_conn_timeout   => 30,
      :ssh_min_pool_conn  => 1,
      :ssh_max_pool_conn  => 5
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
    }
  end

  shared_examples 'cinder::backend::san' do
    context 'with parameters' do
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
        :properties => ['volume_backend_name=mysan']
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
