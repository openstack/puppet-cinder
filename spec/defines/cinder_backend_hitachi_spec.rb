require 'spec_helper'

describe 'cinder::backend::hitachi' do

  let(:title) {'hitachi'}

  let :default_params do
    {
      :hitachi_pool_id            => '1',
      :hitachi_vol_pool_id        => '0',
      :hitachi_vol_thin_pool_id   => '0',
      :hitachi_target_ports       => 'CL1-A',
      :hitachi_default_copy_method        => 'THIN',
      :hitachi_copy_speed        => '3',
      :hitachi_copy_check_interval        => '3',
      :hitachi_async_copy_check_interval        => '10',
      :hitachi_horcm_user         => 'maintenance',
      :hitachi_horcm_password     => 'maintenance',
      :hitachi_horcm_numbers     => '200,201',
      :hitachi_rminst_user         => 'maintenance',
      :hitachi_rminst_password     => 'maintenance',
      :hitachi_serial_number     => '211975',
      :hitachi_unit_name           => '',
      :hitachi_ldev_range          => '',
      :hitachi_rminst_add_conf     => 'False',
      :hitachi_horcm_add_conf     => 'False',
      :hitachi_zoning_request     => 'true',
      :hitachi_group_request     => 'true',
      :hitachi_group_range     => '',
      :hitachi_add_chap_user   => 'False',
      :hitachi_auth_method   => 'None',
      :hitachi_auth_user   => '',
      :hitachi_auth_password   => '',
      :hitachi_debug_level     => 'debug',
      :volume_backend_name    => 'hus100_backend',
    }
  end

 shared_examples_for 'hitachi volume driver' do

    it 'configures hitachi volume driver' do
      is_expected.to contain_cinder_config("#{default_params[:volume_backend_name]}/volume_driver").with_value(
        'cinder.volume.drivers.hitachi.hbsd_fc.HBSDFCDriver')
      params_hash.each_pair do |config,value|
        is_expected.to contain_cinder_config("#{default_params[:volume_backend_name]}/#{config}").with_value( value )
      end
    end

  end


  context 'with default parameters' do
    before do
      params = {}
    end

    it_configures 'hitachi volume driver'
  end

  context 'with provided parameters' do
    it_configures 'hitachi volume driver'
  end

  context 'hitachi backend with additional configuration' do
    before do
      params.merge!({:extra_options => {'hitachi/param1' => { 'value' => 'value1' }}})
    end

    it 'configure hds backend with additional configuration' do
      should contain_cinder_config('hitachi/param1').with({
        :value => 'value1'
      })
    end
  end

end
