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
    OSDefaults.get_facts({
      :osfamily => 'Debian',
      :os       => { :name  => 'Debian', :family => 'Debian', :release => { :major => '8', :minor => '0' } },
    })
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
      is_expected.to contain_cinder_config('nvme-backend/backend_availability_zone').with(
        :value => '<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('nvme-backend/volume_driver').with(
        :value => 'cinder.volume.drivers.lvm.LVMVolumeDriver')
    end

    it { is_expected.to contain_package('nvmetcli').with(
      :name   => 'nvmetcli',
      :ensure => 'present',
      :tag    => 'cinder-support-package',
    ) }

    it { is_expected.to contain_package('nvme-cli').with(
      :name   => 'nvme-cli',
      :ensure => 'present',
      :tag    => 'cinder-support-package',
    ) }

  end

end
