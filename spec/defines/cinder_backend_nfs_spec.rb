require 'spec_helper'

describe 'cinder::backend::nfs' do
  let(:title) {'hippo'}

  let :params do
    {
      :nfs_servers => ['10.10.10.10:/shares', '10.10.10.10:/shares2'],
    }
  end

  shared_examples 'cinder::backend::nfs' do
    context 'with defaults' do
      it {
        is_expected.to contain_cinder_config('hippo/volume_backend_name').with_value('hippo')
        is_expected.to contain_cinder_config('hippo/backend_availability_zone').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hippo/volume_driver').with_value('cinder.volume.drivers.nfs.NfsDriver')
        is_expected.to contain_cinder_config('hippo/max_over_subscription_ratio').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hippo/nfs_shares_config').with_value('/etc/cinder/shares.conf')
        is_expected.to contain_cinder_config('hippo/nfs_mount_attempts').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hippo/nfs_mount_options').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hippo/nfs_sparsed_volumes').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hippo/nfs_mount_point_base').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hippo/nfs_used_ratio').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hippo/nfs_oversub_ratio').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hippo/nas_secure_file_operations').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hippo/nas_secure_file_permissions').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hippo/nfs_snapshot_support').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hippo/nfs_qcow2_volumes').with_value('<SERVICE DEFAULT>')
      }

      it {
        is_expected.to contain_package('nfs-client').with(
          :name   => platform_params[:nfs_client_package_name],
          :ensure => 'installed',
        )
      }

      it { is_expected.to contain_file('/etc/cinder/shares.conf').with(
        :content => "10.10.10.10:/shares\n10.10.10.10:/shares2",
        :require => 'Anchor[cinder::install::end]',
        :notify  => 'Anchor[cinder::service::begin]'
      )}
    end

    context 'with parameters' do
      before :each do
        params.merge!({
          :backend_availability_zone   => 'my_zone',
          :max_over_subscription_ratio => 1.5,
          :nfs_mount_attempts          => '4',
          :nfs_mount_options           => 'vers=3',
          :nfs_shares_config           => '/etc/cinder/other_shares.conf',
          :nfs_sparsed_volumes         => true,
          :nfs_mount_point_base        => '/cinder_mount_point',
          :nfs_used_ratio              => '0.7',
          :nfs_oversub_ratio           => '0.9',
          :nas_secure_file_operations  => 'auto',
          :nas_secure_file_permissions => 'false',
          :nfs_snapshot_support        => 'true',
          :nfs_qcow2_volumes           => 'true',
        })
      end

      it {
        is_expected.to contain_cinder_config('hippo/volume_backend_name').with_value('hippo')
        is_expected.to contain_cinder_config('hippo/backend_availability_zone').with_value('my_zone')
        is_expected.to contain_cinder_config('hippo/volume_driver').with_value('cinder.volume.drivers.nfs.NfsDriver')
        is_expected.to contain_cinder_config('hippo/max_over_subscription_ratio').with_value(1.5)
        is_expected.to contain_cinder_config('hippo/nfs_shares_config').with_value('/etc/cinder/other_shares.conf')
        is_expected.to contain_cinder_config('hippo/nfs_mount_attempts').with_value('4')
        is_expected.to contain_cinder_config('hippo/nfs_mount_options').with_value('vers=3')
        is_expected.to contain_cinder_config('hippo/nfs_sparsed_volumes').with_value(true)
        is_expected.to contain_cinder_config('hippo/nfs_mount_point_base').with_value('/cinder_mount_point')
        is_expected.to contain_cinder_config('hippo/nfs_used_ratio').with_value('0.7')
        is_expected.to contain_cinder_config('hippo/nfs_oversub_ratio').with_value('0.9')
        is_expected.to contain_cinder_config('hippo/nas_secure_file_operations').with_value('auto')
        is_expected.to contain_cinder_config('hippo/nas_secure_file_permissions').with_value('false')
        is_expected.to contain_cinder_config('hippo/nfs_snapshot_support').with_value('true')
        is_expected.to contain_cinder_config('hippo/nfs_qcow2_volumes').with_value('true')
      }

      it { is_expected.to contain_file('/etc/cinder/other_shares.conf').with(
        :content => "10.10.10.10:/shares\n10.10.10.10:/shares2",
        :require => 'Anchor[cinder::install::end]',
        :notify  => 'Anchor[cinder::service::begin]'
      )}
    end

    context 'nfs backend with additional configuration' do
      before :each do
        params.merge!( :extra_options => {'hippo/param1' => {'value' => 'value1'}} )
      end

      it { is_expected.to contain_cinder_config('hippo/param1').with_value('value1') }
    end

    context 'nfs backend with cinder type' do
      before :each do
        params.merge!( :manage_volume_type => true )
      end

      it { is_expected.to contain_cinder_type('hippo').with(
        :ensure     => 'present',
        :properties => {'volume_backend_name' => 'hippo'}
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

      let :platform_params do
        case facts[:os]['family']
        when 'Debian'
          { :nfs_client_package_name => 'nfs-common' }
        when 'RedHat'
          { :nfs_client_package_name => 'nfs-utils' }
        end
      end

      it_behaves_like 'cinder::backend::nfs'
    end
  end
end
