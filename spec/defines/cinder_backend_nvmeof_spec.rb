require 'spec_helper'

describe 'cinder::backend::nvmeof' do
  let(:title) {'nvme-backend'}

  let :req_params do
    {
      :target_ip_address => '127.0.0.2',
      :target_helper     => 'nvmet',
      :target_protocol   => 'nvmet_rdma',
    }
  end

  let :params do
    req_params
  end

  shared_examples 'cinder::backend::nvmeof' do
    context 'with default params' do
      it {
        is_expected.to contain_cinder_config('nvme-backend/target_ip_address').with_value('127.0.0.2')
        is_expected.to contain_cinder_config('nvme-backend/target_port').with_value('4420')
        is_expected.to contain_cinder_config('nvme-backend/target_helper').with_value('nvmet')
        is_expected.to contain_cinder_config('nvme-backend/target_protocol').with_value('nvmet_rdma')
        is_expected.to contain_cinder_config('nvme-backend/nvmet_port_id').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('nvme-backend/nvmet_ns_id').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('nvme-backend/volume_backend_name').with_value('nvme-backend')
        is_expected.to contain_cinder_config('nvme-backend/backend_availability_zone').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('nvme-backend/image_volume_cache_enabled').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('nvme-backend/image_volume_cache_max_size_gb').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('nvme-backend/image_volume_cache_max_count').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('nvme-backend/reserved_percentage').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('nvme-backend/volume_driver').with_value('cinder.volume.drivers.lvm.LVMVolumeDriver')
        is_expected.to contain_cinder_config('nvme-backend/nvmeof_conn_info_version').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('nvme-backend/lvm_share_target').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('nvme-backend/target_secondary_ip_addresses').with_value('<SERVICE DEFAULT>')
      }

      it { is_expected.to contain_package('nvmetcli').with(
        :name   => 'nvmetcli',
        :ensure => 'installed',
        :tag    => 'cinder-support-package',
      )}

      it { is_expected.to contain_package('nvme-cli').with(
        :name   => 'nvme-cli',
        :ensure => 'installed',
        :tag    => 'cinder-support-package',
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

      it_behaves_like 'cinder::backend::nvmeof'
    end
  end
end
