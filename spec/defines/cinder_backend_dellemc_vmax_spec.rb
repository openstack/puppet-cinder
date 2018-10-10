require 'spec_helper'

describe 'cinder::backend::dellemc_vmax_iscsi' do
  let (:title) { 'dellemc_vmax_iscsi' }

  let :req_params do
    {
      :cinder_emc_config_file => '/etc/cinder/cinder_emc_config_CONF_GROUP_ISCSI.xml',
      :volume_backend_name    => 'dellemc_vmax_iscsi',
    }
  end

  let :params do
    req_params
  end

  describe 'dell emc vmax iscsi volume driver' do
    it 'configure dell emc vmax iscsi volume driver' do
      is_expected.to contain_package('pywbem').with(:ensure => :present)
      is_expected.to contain_cinder_config('dellemc_vmax_iscsi/volume_driver').with_value('cinder.volume.drivers.dell_emc.vmax.iscsi.VMAXISCSIDriver')
      is_expected.to contain_cinder_config('dellemc_vmax_iscsi/cinder_emc_config_file').with_value('/etc/cinder/cinder_emc_config_CONF_GROUP_ISCSI.xml')
    end
  end

  describe 'dell emc vmax iscsi backend overriding some parameters' do
    before :each do
      params.merge!({
       :backend_availability_zone     => 'my_zone',
       :manage_volume_type            => true,
      })
    end

    it 'configure dell emc vmax iscsi volume driver' do
      is_expected.to contain_cinder_config('dellemc_vmax_iscsi/cinder_emc_config_file').with_value('/etc/cinder/cinder_emc_config_CONF_GROUP_ISCSI.xml')
      is_expected.to contain_cinder_config('dellemc_vmax_iscsi/backend_availability_zone').with_value('my_zone')
    end

    it 'should create type with properties' do
      should contain_cinder_type('dellemc_vmax_iscsi').with(:ensure => :present, :properties => ['volume_backend_name=dellemc_vmax_iscsi'])
    end
  end

  describe 'dell emc vmax iscsi backend with additional configuration' do
    before :each do
      params.merge!({:extra_options => {'dellemc_vmax_iscsi/param1' => {'value' => 'value1'}}})
    end

    it 'configure dell emc vmax iscsi backend with additional configuration' do
      is_expected.to contain_cinder_config('dellemc_vmax_iscsi/param1').with({
        :value => 'value1',
      })
    end
  end

end
