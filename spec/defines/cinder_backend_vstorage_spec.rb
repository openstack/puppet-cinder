require 'spec_helper'

describe 'cinder::backend::vstorage' do
  let(:title) {'vstorage'}

  let :params do
    {
      :cluster_name              => 'stor1',
      :cluster_password          => 'passw0rd',
      :backend_availability_zone => 'my_zone',
      :shares_config_path        => '/etc/cinder/vstorage_shares.conf',
      :use_sparsed_volumes       => true,
      :used_ratio                => '0.9',
      :mount_point_base          => '/vstorage',
      :default_volume_format     => 'ploop',
      :mount_user                => 'cinder',
      :mount_group               => 'root',
      :mount_permissions         => '0770',
      :manage_package            => true,
    }
  end

  shared_examples 'cinder::backend::vstorage' do
    it {
      is_expected.to contain_cinder_config('vstorage/volume_backend_name').with_value('vstorage')
      is_expected.to contain_cinder_config('vstorage/backend_availability_zone').with_value('my_zone')
      is_expected.to contain_cinder_config('vstorage/vzstorage_sparsed_volumes').with_value(true)
      is_expected.to contain_cinder_config('vstorage/vzstorage_used_ratio').with_value('0.9')
      is_expected.to contain_cinder_config('vstorage/vzstorage_mount_point_base').with_value('/vstorage')
      is_expected.to contain_cinder_config('vstorage/vzstorage_default_volume_format').with_value('ploop')
    }

    it { is_expected.to contain_cinder_config('vstorage/vzstorage_shares_config').with(
      :value => '/etc/cinder/vstorage_shares.conf'
    )}

    it { is_expected.to contain_cinder_config('vstorage/volume_driver').with(
      :value => 'cinder.volume.drivers.vzstorage.VZStorageDriver'
    )}

    it { is_expected.to contain_package('vstorage-client').with_ensure('present') }

    it { is_expected.to contain_file('/etc/cinder/vstorage_shares.conf').with(
      :content => "stor1:passw0rd [\"-u\", \"cinder\", \"-g\", \"root\", \"-m\", \"0770\"]"
    )}

    context 'vstorage backend with cinder type' do
      before do
        params.merge!( :manage_volume_type => true )
      end

      it { is_expected.to contain_cinder_type('vstorage').with(
        :ensure => 'present',
        :properties => ['vz:volume_format=qcow2']
      )}

      it { is_expected.to contain_cinder_type('vstorage-ploop').with(
        :ensure => 'present',
        :properties => ['vz:volume_format=ploop']
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

      it_behaves_like 'cinder::backend::vstorage'
    end
  end
end
