require 'spec_helper'

describe 'cinder::backend::glusterfs' do
  let(:title) {'mygluster'}

  let :params do
    {
      :backend_availability_zone  => 'my_zone',
      :glusterfs_shares           => ['10.10.10.10:/volumes', '10.10.10.11:/volumes'],
      :glusterfs_shares_config    => '/etc/cinder/other_shares.conf',
      :glusterfs_sparsed_volumes  => true,
      :glusterfs_mount_point_base => '/cinder_mount_point',
    }
  end

  shared_examples 'glusterfs volume driver' do
    it { is_expected.to contain_cinder_config('mygluster/volume_driver').with(
      :value => 'cinder.volume.drivers.glusterfs.GlusterfsDriver'
    )}

    it {
      is_expected.to contain_cinder_config('mygluster/backend_availability_zone').with_value('my_zone')
      is_expected.to contain_cinder_config('mygluster/glusterfs_backup_mount_point').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('mygluster/glusterfs_backup_share').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('mygluster/glusterfs_shares_config').with_value('/etc/cinder/other_shares.conf')
      is_expected.to contain_cinder_config('mygluster/glusterfs_sparsed_volumes').with_value(true)
      is_expected.to contain_cinder_config('mygluster/glusterfs_mount_point_base').with_value('/cinder_mount_point')
    }

    it { is_expected.to contain_file('/etc/cinder/other_shares.conf').with(
      :content => "10.10.10.10:/volumes\n10.10.10.11:/volumes\n",
      :require => 'Anchor[cinder::install::end]',
      :notify  => 'Anchor[cinder::service::begin]'
    )}

    context 'glusterfs backend with additional configuration' do
      before do
        params.merge!( :extra_options => {'mygluster/param1' => { 'value' => 'value1' }} )
      end

      it { is_expected.to contain_cinder_config('mygluster/param1').with_value('value1') }
    end

    context 'glusterfs backend with cinder type' do
      before do
        params.merge!( :manage_volume_type => true )
      end

      it { is_expected.to contain_cinder_type('mygluster').with(
        :ensure     => 'present',
        :properties => ['volume_backend_name=mygluster']
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts( :os_workers => 8 ))
      end

      it_behaves_like 'glusterfs volume driver'
    end
  end
end
