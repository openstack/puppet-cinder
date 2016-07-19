require 'spec_helper'

describe 'cinder::volume::nfs' do

  let :params do
    {
      :nfs_servers          => ['10.10.10.10:/shares', '10.10.10.10:/shares2'],
      :nfs_mount_options    => 'vers=3',
      :nfs_shares_config    => '/etc/cinder/other_shares.conf',
      :nfs_disk_util        => 'du',
      :nfs_sparsed_volumes  => true,
      :nfs_mount_point_base => '/cinder_mount_point',
      :nfs_used_ratio       => '0.95',
      :nfs_oversub_ratio    => '1.0',
    }
  end

  let :facts do
    OSDefaults.get_facts({})
  end

  describe 'nfs volume driver' do
    it 'configures nfs volume driver' do
      is_expected.to contain_cinder_config('DEFAULT/volume_driver').with_value(
        'cinder.volume.drivers.nfs.NfsDriver')
      is_expected.to contain_cinder_config('DEFAULT/nfs_shares_config').with_value(
        '/etc/cinder/other_shares.conf')
      is_expected.to contain_cinder_config('DEFAULT/nfs_mount_options').with_value(
        'vers=3')
      is_expected.to contain_cinder_config('DEFAULT/nfs_sparsed_volumes').with_value(
        true)
      is_expected.to contain_cinder_config('DEFAULT/nfs_mount_point_base').with_value(
        '/cinder_mount_point')
      is_expected.to contain_cinder_config('DEFAULT/nfs_disk_util').with_value(
        'du')
      is_expected.to contain_cinder_config('DEFAULT/nfs_used_ratio').with_value(
        '0.95')
      is_expected.to contain_cinder_config('DEFAULT/nfs_oversub_ratio').with_value(
        '1.0')
      is_expected.to contain_file('/etc/cinder/other_shares.conf').with(
        :content => "10.10.10.10:/shares\n10.10.10.10:/shares2",
        :require => 'Anchor[cinder::install::end]',
        :notify  => 'Anchor[cinder::service::begin]'
      )
    end
  end

  describe 'nfs volume driver with additional configuration' do
    before :each do
      params.merge!({
        :nfs_mount_attempts => 4,
        :extra_options => {'nfs_backend/param1' => {'value' => 'value1'}}})
    end

    it 'configure nfs volume with additional configuration' do
      is_expected.to contain_cinder__backend__nfs('DEFAULT').with({
        :nfs_mount_attempts => params[:nfs_mount_attempts],
        :extra_options => {'nfs_backend/param1' => {'value' => 'value1'}}
      })
    end
  end


end
