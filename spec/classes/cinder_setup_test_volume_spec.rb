require 'spec_helper'

describe 'cinder::setup_test_volume' do
  shared_examples 'cinder::setup_test_volume' do
    it { is_expected.to contain_package('lvm2').with(
      :ensure => 'present',
      :tag    => 'cinder-support-package'
    )}

    it {
      is_expected.to contain_exec('create_/var/lib/cinder/cinder-volumes').with(
        :command => 'dd if=/dev/zero of="/var/lib/cinder/cinder-volumes" bs=1 count=0 seek=4G',
        :path    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
        :unless  => 'stat /var/lib/cinder/cinder-volumes',
      )
      is_expected.to contain_exec('losetup /dev/loop2 /var/lib/cinder/cinder-volumes').with(
        :command     => 'losetup /dev/loop2 /var/lib/cinder/cinder-volumes && udevadm settle',
        :path        => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
        :unless      => 'losetup /dev/loop2',
      )
      is_expected.to contain_exec('pvcreate /dev/loop2').with(
        :path        => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
        :unless      => 'pvdisplay | grep cinder-volumes',
        :refreshonly => true,
      )
      is_expected.to contain_exec('vgcreate cinder-volumes /dev/loop2').with(
        :path        => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
        :unless      => 'vgdisplay | grep cinder-volumes',
        :refreshonly => true,
      )
    }

    it { is_expected.to contain_file('/var/lib/cinder/cinder-volumes').with_mode('0640') }
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder::setup_test_volume'
    end
  end
end
