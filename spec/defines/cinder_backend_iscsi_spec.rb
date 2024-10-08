require 'spec_helper'

describe 'cinder::backend::iscsi' do
  let(:title) {'hippo'}

  shared_examples 'cinder::backend::iscsi' do
    context 'with default params' do
      it {
        is_expected.to contain_cinder_config('hippo/volume_backend_name').with_value('hippo')
        is_expected.to contain_cinder_config('hippo/image_volume_cache_enabled').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hippo/image_volume_cache_max_size_gb').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hippo/image_volume_cache_max_count').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hippo/backend_availability_zone').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hippo/reserved_percentage').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hippo/max_over_subscription_ratio').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hippo/volume_driver').with_value('cinder.volume.drivers.lvm.LVMVolumeDriver')
        is_expected.to contain_cinder_config('hippo/target_ip_address').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hippo/target_helper').with_value(platform_params[:target_helper])
        is_expected.to contain_cinder_config('hippo/volume_group').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hippo/volumes_dir').with_value('/var/lib/cinder/volumes')
        is_expected.to contain_cinder_config('hippo/target_protocol').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hippo/lvm_type').with_value('<SERVICE DEFAULT>')
      }
    end

    context 'with parameters' do
      let :params do
        {
          :backend_availability_zone      => 'nova',
          :image_volume_cache_enabled     => true,
          :image_volume_cache_max_size_gb => 100,
          :image_volume_cache_max_count   => 101,
          :reserved_percentage            => 10,
          :max_over_subscription_ratio    => 1.5,
          :target_ip_address              => '192.0.2.1',
          :volume_group                   => 'volumegroup',
          :volumes_dir                    => '/etc/cinder/volumes',
          :target_protocol                => 'iser',
          :lvm_type                       => 'auto',
        }
      end
      it {
        is_expected.to contain_cinder_config('hippo/backend_availability_zone').with_value('nova')
        is_expected.to contain_cinder_config('hippo/image_volume_cache_enabled').with_value(true)
        is_expected.to contain_cinder_config('hippo/image_volume_cache_max_size_gb').with_value(100)
        is_expected.to contain_cinder_config('hippo/image_volume_cache_max_count').with_value(101)
        is_expected.to contain_cinder_config('hippo/reserved_percentage').with_value(10)
        is_expected.to contain_cinder_config('hippo/max_over_subscription_ratio').with_value(1.5)
        is_expected.to contain_cinder_config('hippo/target_ip_address').with_value('192.0.2.1')
        is_expected.to contain_cinder_config('hippo/volume_group').with_value('volumegroup')
        is_expected.to contain_cinder_config('hippo/volumes_dir').with_value('/etc/cinder/volumes')
        is_expected.to contain_cinder_config('hippo/target_protocol').with_value('iser')
        is_expected.to contain_cinder_config('hippo/lvm_type').with_value('auto')
      }
    end

    context 'with tatadm' do
      let :params do
        {
          :target_helper => 'tgtadm',
        }
      end
      it {
        is_expected.to contain_cinder_config('hippo/target_helper').with_value('tgtadm')
      }
      it { is_expected.to contain_package('tgt').with(
        :ensure => 'installed',
        :name   => platform_params[:tgt_package_name],
        :tag    => 'cinder-support-package',
      ) }
      it { is_expected.to contain_file_line('cinder include /var/lib/cinder/volumes').with(
        :line => 'include /var/lib/cinder/volumes/*',
        :path => '/etc/tgt/targets.conf'
      )}
      it { is_expected.to contain_service('tgtd').with(
        :ensure => 'running',
        :enable => true,
        :name   => platform_params[:tgt_service_name],
        :tag    => 'cinder-support-service',
      ) }
    end

    context 'with lioadm' do
      let :params do
        {
          :target_helper => 'lioadm',
        }
      end

      it {
        is_expected.to contain_cinder_config('hippo/target_helper').with_value('lioadm')
      }
      it { is_expected.to contain_package('targetcli').with(
        :ensure => 'installed',
        :name   => platform_params[:lio_package_name],
        :tag    => 'cinder-support-package',
      ) }
      it { is_expected.to contain_service('target').with(
        :ensure => 'running',
        :enable => true,
        :tag    => 'cinder-support-service',
      ) }
    end

    context 'iscsi backend with cinder type' do
     let :params do
        {
          :manage_volume_type => true
        }
      end

      it { is_expected.to contain_cinder_type('hippo').with(
        :ensure     => 'present',
        :properties => {'volume_backend_name' => 'hippo'}
      )}
    end

    context 'iscsi backend with additional configuration' do
      let :params do
        {
          :extra_options => {
            'hippo/param1' => {'value' => 'value1'},
          }
        }
      end

      it { is_expected.to contain_cinder_config('hippo/param1').with(
        :value => 'value1',
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
          {
            :target_helper    => 'tgtadm',
            :tgt_package_name => 'tgt',
            :tgt_service_name => 'tgt',
            :lio_package_name => 'targetcli',
          }
        when 'RedHat'
          {
            :target_helper    => 'lioadm',
            :tgt_package_name => 'scsi-target-utils',
            :tgt_service_name => 'tgtd',
            :lio_package_name => 'targetcli',
          }
        end
      end

      it_behaves_like 'cinder::backend::iscsi'
    end
  end
end
