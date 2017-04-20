require 'spec_helper'

describe 'cinder::backend::vstorage' do

  let(:title) {'vstorage'}

  let :params do
    {
      :cluster_name          => 'stor1',
      :cluster_password      => 'passw0rd',
      :shares_config_path    => '/etc/cinder/vstorage_shares.conf',
      :use_sparsed_volumes   => true,
      :used_ratio            => '0.9',
      :mount_point_base      => '/vstorage',
      :default_volume_format => 'ploop',
      :mount_user            => 'cinder',
      :mount_group           => 'root',
      :mount_permissions     => '0770',
      :manage_package        => true,
    }
  end

  it 'configures vstorage volume driver' do
    is_expected.to contain_cinder_config('vstorage/volume_backend_name').with(
      :value => 'vstorage')
    is_expected.to contain_cinder_config('vstorage/volume_driver').with_value(
      'cinder.volume.drivers.vzstorage.VZStorageDriver')
    is_expected.to contain_cinder_config('vstorage/vzstorage_shares_config').with_value(
      '/etc/cinder/vstorage_shares.conf')
    is_expected.to contain_cinder_config('vstorage/vzstorage_sparsed_volumes').with_value(
      true)
    is_expected.to contain_cinder_config('vstorage/vzstorage_used_ratio').with_value(
      '0.9')
    is_expected.to contain_cinder_config('vstorage/vzstorage_mount_point_base').with_value(
      '/vstorage')
    is_expected.to contain_cinder_config('vstorage/vzstorage_default_volume_format').with_value(
      'ploop')
  end

  it 'installs vstorage-client package' do
    is_expected.to contain_package('vstorage-client').with(
      :ensure => 'present')
  end

  it 'creates shares config file' do
    is_expected.to contain_file('/etc/cinder/vstorage_shares.conf').with_content(
      "stor1:passw0rd [\"-u\", \"cinder\", \"-g\", \"root\", \"-m\", \"0770\"]"
    )
  end

  context 'vstorage backend with cinder type' do
    before do
      params.merge!({:manage_volume_type => true})
    end
    it 'should create volume type' do
      should contain_cinder_type('vstorage').with(
        :ensure => :present,
        :properties => ['volume_backend_name=vstorage'])
    end
  end

end
