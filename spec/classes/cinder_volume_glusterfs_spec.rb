require 'spec_helper'

describe 'cinder::volume::glusterfs' do

  let :params do
    {
      :glusterfs_shares           => ['10.10.10.10:/volumes', '10.10.10.11:/volumes'],
      :glusterfs_shares_config    => '/etc/cinder/other_shares.conf',
      :glusterfs_disk_util        => 'du',
      :glusterfs_sparsed_volumes  => true,
      :glusterfs_mount_point_base => '/cinder_mount_point',
    }
  end

  describe 'glusterfs volume driver' do
    it 'configures glusterfs volume driver' do
      should contain_cinder_config('DEFAULT/volume_driver').with_value(
        'cinder.volume.drivers.glusterfs.GlusterfsDriver')
      should contain_cinder_config('DEFAULT/glusterfs_shares_config').with_value(
        '/etc/cinder/other_shares.conf')
      should contain_cinder_config('DEFAULT/glusterfs_sparsed_volumes').with_value(
        true)
      should contain_cinder_config('DEFAULT/glusterfs_mount_point_base').with_value(
        '/cinder_mount_point')
      should contain_cinder_config('DEFAULT/glusterfs_disk_util').with_value(
        'du')
      should contain_file('/etc/cinder/other_shares.conf').with(
        :content => "10.10.10.10:/volumes\n10.10.10.11:/volumes\n",
        :require => 'Package[cinder]',
        :notify  => 'Service[cinder-volume]'
      )
    end
  end
end
