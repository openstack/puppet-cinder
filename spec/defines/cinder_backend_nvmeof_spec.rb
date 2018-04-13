require 'spec_helper'

describe 'cinder::backend::nvmeof' do

  let(:title) {'nvme-backend'}

  let :req_params do {
    :target_ip_address => '127.0.0.2',
    :target_port => '4420',
    :target_helper => 'nvmet',
    :target_protocol => 'nvmet_rdma',
  }
  end

  let :facts do
    OSDefaults.get_facts({:osfamily => 'Debian'})
  end

  let :params do
    req_params
  end

  describe 'with default params' do

    it 'should configure nvmet target' do
      is_expected.to contain_cinder_config('nvme-backend/target_ip_address').with(
        :value => '127.0.0.2')
      is_expected.to contain_cinder_config('nvme-backend/target_port').with(
        :value => '4420')
      is_expected.to contain_cinder_config('nvme-backend/target_helper').with(
        :value => 'nvmet')
      is_expected.to contain_cinder_config('nvme-backend/target_protocol').with(
        :value => 'nvmet_rdma')
      is_expected.to contain_cinder_config('nvme-backend/nvmet_port_id').with(
        :value => '1')
      is_expected.to contain_cinder_config('nvme-backend/nvmet_ns_id').with(
        :value => '10')
      is_expected.to contain_cinder_config('nvme-backend/volume_backend_name').with(
        :value => 'nvme-backend')
      is_expected.to contain_cinder_config('nvme-backend/volume_driver').with(
        :value => 'cinder.volume.drivers.lvm.LVMVolumeDriver')
    end
  end

end
