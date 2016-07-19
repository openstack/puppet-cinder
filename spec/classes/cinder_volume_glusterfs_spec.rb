require 'spec_helper'

describe 'cinder::volume::glusterfs' do

  shared_examples_for 'glusterfs volume driver' do
    let :params do
      {
        :glusterfs_shares           => ['10.10.10.10:/volumes', '10.10.10.11:/volumes'],
        :glusterfs_shares_config    => '/etc/cinder/other_shares.conf',
        :glusterfs_sparsed_volumes  => true,
        :glusterfs_mount_point_base => '/cinder_mount_point',
      }
    end

    it 'configures glusterfs volume driver' do
      is_expected.to contain_cinder_config('DEFAULT/volume_driver').with_value('cinder.volume.drivers.glusterfs.GlusterfsDriver')
      is_expected.to contain_cinder_config('DEFAULT/glusterfs_shares_config').with_value('/etc/cinder/other_shares.conf')
      is_expected.to contain_cinder_config('DEFAULT/glusterfs_sparsed_volumes').with_value(true)
      is_expected.to contain_cinder_config('DEFAULT/glusterfs_mount_point_base').with_value('/cinder_mount_point')
      is_expected.to contain_cinder_config('DEFAULT/glusterfs_backup_mount_point').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('DEFAULT/glusterfs_backup_share').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_file('/etc/cinder/other_shares.conf').with(
        :content => "10.10.10.10:/volumes\n10.10.10.11:/volumes\n",
        :require => 'Anchor[cinder::install::end]',
        :notify  => 'Anchor[cinder::service::begin]'
      )
    end

    context 'glusterfs volume driver with additional configuration' do
      before do
        params.merge!({:extra_options => {'glusterfs_backend/param1' => { 'value' => 'value1' }}})
      end

      it 'configure glusterfs volume with additional configuration' do
        is_expected.to contain_cinder__backend__glusterfs('DEFAULT').with({
          :extra_options => {'glusterfs_backend/param1' => {'value' => 'value1'}}
        })
      end

    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({:processorcount => 8}))
      end

      it_configures 'glusterfs volume driver'
    end
  end

end
