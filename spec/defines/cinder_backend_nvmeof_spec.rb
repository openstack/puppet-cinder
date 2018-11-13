require 'spec_helper'

describe 'cinder::backend::nvmeof' do
  let(:title) {'nvme-backend'}

  let :req_params do
    {
      :target_ip_address => '127.0.0.2',
      :target_port       => '4420',
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
        should contain_cinder_config('nvme-backend/target_ip_address').with_value('127.0.0.2')
        should contain_cinder_config('nvme-backend/target_port').with_value('4420')
        should contain_cinder_config('nvme-backend/target_helper').with_value('nvmet')
        should contain_cinder_config('nvme-backend/target_protocol').with_value('nvmet_rdma')
        should contain_cinder_config('nvme-backend/nvmet_port_id').with_value('1')
        should contain_cinder_config('nvme-backend/nvmet_ns_id').with_value('10')
        should contain_cinder_config('nvme-backend/volume_backend_name').with_value('nvme-backend')
        should contain_cinder_config('nvme-backend/backend_availability_zone').with_value('<SERVICE DEFAULT>')
        should contain_cinder_config('nvme-backend/volume_driver').with_value('cinder.volume.drivers.lvm.LVMVolumeDriver')
      }

      it { should contain_package('nvmetcli').with(
        :name   => 'nvmetcli',
        :ensure => 'present',
        :tag    => 'cinder-support-package',
      )}

      it { should contain_package('nvme-cli').with(
        :name   => 'nvme-cli',
        :ensure => 'present',
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
