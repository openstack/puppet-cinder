# author 'Aimon Bustardo <abustardo at morphlabs dot com>'
# license 'Apache License 2.0'
# description 'configures openstack cinder nexenta driver'
require 'spec_helper'

describe 'cinder::backend::nexenta' do
  let (:title) { 'nexenta' }

  let :params do
    {
      :nexenta_user     => 'nexenta',
      :nexenta_password => 'password',
      :nexenta_host     => '127.0.0.2'
    }
  end

  let :default_params do
    {
      :nexenta_volume              => 'cinder',
      :nexenta_target_prefix       => 'iqn:',
      :nexenta_target_group_prefix => 'cinder/',
      :nexenta_blocksize           => '8192',
      :nexenta_sparse              => true,
      :nexenta_rest_port           => '8457',
      :volume_driver               => 'cinder.volume.drivers.nexenta.iscsi.NexentaISCSIDriver',
      :backend_availability_zone   => '<SERVICE DEFAULT>',
    }
  end

  shared_examples 'cinder::backend::nexenta' do
    context 'with required params' do
      let :params_hash do
        default_params.merge(params)
      end

      it {
        params_hash.each_pair do |config, value|
          should contain_cinder_config("nexenta/#{config}").with_value(value)
        end
      }
    end

    context 'nexenta backend with additional configuration' do
      before do
        params.merge!( :extra_options => {'nexenta/param1' => { 'value' => 'value1' }} )
      end

      it { should contain_cinder_config('nexenta/param1').with_value('value1') }
    end

    context 'nexenta backend with cinder type' do
      before do
        params.merge!( :manage_volume_type => true )
      end

      it { should contain_cinder_type('nexenta').with(
        :ensure     => 'present',
        :properties => ['volume_backend_name=nexenta']
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

      it_behaves_like 'cinder::backend::nexenta'
    end
  end
end
