require 'spec_helper'

describe 'cinder::backend::dellemc_powermax_iscsi' do
  let (:title) { 'dellemc_powermax_iscsi' }

  let :req_params do
    {
      :cinder_emc_config_file => '/etc/cinder/cinder_emc_config_CONF_GROUP_ISCSI.xml',
      :volume_backend_name    => 'dellemc_powermax_iscsi',
    }
  end

  let :params do
    req_params
  end

  shared_examples 'cinder::backend::dellemc_powermax_iscsi' do
    context 'dell emc powermax iscsi volume driver' do
      it {
        should contain_package('pywbem').with(:ensure => :present)
        should contain_cinder_config('dellemc_powermax_iscsi/volume_driver').with_value('cinder.volume.drivers.dell_emc.powermax.iscsi.PowerMaxISCSIDriver')
        should contain_cinder_config('dellemc_powermax_iscsi/cinder_emc_config_file').with_value('/etc/cinder/cinder_emc_config_CONF_GROUP_ISCSI.xml')
      }
    end

    context 'dell emc powermax iscsi backend overriding some parameters' do
      before :each do
        params.merge!({
         :backend_availability_zone => 'my_zone',
         :manage_volume_type        => true,
        })
      end

      it {
        should contain_cinder_config('dellemc_powermax_iscsi/cinder_emc_config_file').with_value('/etc/cinder/cinder_emc_config_CONF_GROUP_ISCSI.xml')
        should contain_cinder_config('dellemc_powermax_iscsi/backend_availability_zone').with_value('my_zone')
      }

      it { should contain_cinder_type('dellemc_powermax_iscsi').with(
        :ensure     => 'present',
        :properties => ['volume_backend_name=dellemc_powermax_iscsi']
      )}
    end

    context 'dell emc powermax iscsi backend with additional configuration' do
      before :each do
        params.merge!( :extra_options => {'dellemc_powermax_iscsi/param1' => {'value' => 'value1'}} )
      end

      it { should contain_cinder_config('dellemc_powermax_iscsi/param1').with_value('value1') }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder::backend::dellemc_powermax_iscsi'
    end
  end
end
