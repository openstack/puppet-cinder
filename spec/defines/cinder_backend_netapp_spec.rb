require 'spec_helper'

describe 'cinder::backend::netapp' do
  let(:title) {'netapp'}

  let :params do
    {
      :volume_backend_name          => 'netapp-cdot-nfs',
      :backend_availability_zone    => 'my_zone',
      :netapp_login                 => 'netapp',
      :netapp_password              => 'password',
      :netapp_server_hostname       => '127.0.0.2',
      :netapp_vfiler                => 'netapp_vfiler',
      :netapp_vserver               => 'netapp_vserver',
      :netapp_partner_backend_name  => 'fc2',
      :netapp_copyoffload_tool_path => '/tmp/na_copyoffload_64',
      :netapp_controller_ips        => '10.0.0.2,10.0.0.3',
      :netapp_sa_password           => 'password',
    }
  end

  let :default_params do
    {
      :backend_availability_zone   => '<SERVICE DEFAULT>',
      :netapp_server_port          => '80',
      :netapp_size_multiplier      => '1.2',
      :netapp_storage_family       => 'ontap_cluster',
      :netapp_storage_protocol     => 'nfs',
      :netapp_transport_type       => 'http',
      :expiry_thres_minutes        => '720',
      :thres_avl_size_perc_start   => '20',
      :thres_avl_size_perc_stop    => '60',
      :nfs_shares_config           => '/etc/cinder/shares.conf',
      :nfs_mount_options           => '<SERVICE DEFAULT>',
      :netapp_webservice_path      => '/devmgr/v2',
      :nas_secure_file_operations  => '<SERVICE DEFAULT>',
      :nas_secure_file_permissions => '<SERVICE DEFAULT>',
    }
  end

  shared_examples 'netapp volume driver' do
    let :params_hash do
      default_params.merge(params)
    end

    it { is_expected.to contain_cinder_config('netapp/volume_driver').with_value('cinder.volume.drivers.netapp.common.NetAppDriver') }

    it {
      params_hash.each_pair do |config,value|
        is_expected.to contain_cinder_config("netapp/#{config}").with_value( value )
      end
    }

    it {
      is_expected.to contain_cinder_config('netapp/netapp_password').with_secret( true )
      is_expected.to contain_cinder_config('netapp/netapp_sa_password').with_secret( true )
    }
  end

  shared_examples 'cinder::backend::netapp' do
    context 'with default parameters' do
      before do
        params = {}
      end

      it_behaves_like 'netapp volume driver'
    end

    context 'with provided parameters' do
      it_behaves_like 'netapp volume driver'
    end

    context 'with netapp_storage_family eseries' do
      before do
        params.merge!( :netapp_storage_family => 'eseries' )
      end

      it { is_expected.to contain_cinder_config('netapp/use_multipath_for_image_xfer').with_value('true') }
    end

    context 'with nfs_mount_options' do
      before do
        params.merge!( :nfs_mount_options => 'rw,proto=tcp,sec=sys' )
      end

      it { is_expected.to contain_cinder_config('netapp/nfs_mount_options').with_value('rw,proto=tcp,sec=sys') }
    end

    context 'netapp backend with cinder type' do
      before do
        params.merge!( :manage_volume_type => true )
      end

      it { is_expected.to contain_cinder_type('netapp').with(
        :ensure     => 'present',
        :properties => ['volume_backend_name=netapp']
      )}
    end

    context 'netapp backend with additional configuration' do
      before do
        params.merge!( :extra_options => {'netapp/param1' => { 'value' => 'value1' }} )
      end

      it { is_expected.to contain_cinder_config('netapp/param1').with_value('value1') }
    end

    context 'with NFS shares provided' do
      before do
        params.merge!( :nfs_shares        => ['10.0.0.1:/test1', '10.0.0.2:/test2'],
                       :nfs_shares_config => '/etc/cinder/shares.conf' )
      end

      it { is_expected.to contain_file('/etc/cinder/shares.conf').with(
        :content => "10.0.0.1:/test1\n10.0.0.2:/test2",
      )}
    end

    context 'with invalid NFS shares provided' do
      before do
        params.merge!({
          :nfs_shares        => "not an array",
          :nfs_shares_config => '/etc/cinder/shares.conf',
        })
      end

      it { is_expected.to raise_error(Puppet::Error) }
    end

    context 'with name search pattern' do
      before do
        params.merge!( :netapp_pool_name_search_pattern => '(something)' )
      end

      it { is_expected.to contain_cinder_config('netapp/netapp_pool_name_search_pattern').with_value('(something)') }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder::backend::netapp'
    end
  end
end
