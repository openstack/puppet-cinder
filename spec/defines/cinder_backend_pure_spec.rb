require 'spec_helper'

describe 'cinder::backend::pure' do
  let (:title) { 'pure' }

  let :req_params do
    {
      :san_ip            => '127.0.0.2',
      :pure_api_token    => 'abc123def456ghi789'
    }
  end

  describe 'pure volume driver defaults' do
    let :params do
      req_params
    end

    it 'configure pure volume driver' do
      is_expected.to contain_cinder_config('pure/volume_driver').with_value('cinder.volume.drivers.pure.PureISCSIDriver')
      is_expected.to contain_cinder_config('pure/san_ip').with_value('127.0.0.2')
      is_expected.to contain_cinder_config('pure/pure_api_token').with_value('abc123def456ghi789')
      is_expected.to contain_cinder_config('pure/use_multipath_for_image_xfer').with_value('true')
      is_expected.to contain_cinder_config('pure/use_chap_auth').with_value('false')
    end
  end

  describe 'pure iscsi volume driver' do
    let :params do
      req_params.merge({
        'pure_storage_protocol' => 'iSCSI',
        'use_chap_auth' => 'true'
      })
    end

    it 'configure pure volume driver' do
      is_expected.to contain_cinder_config('pure/volume_driver').with_value('cinder.volume.drivers.pure.PureISCSIDriver')
      is_expected.to contain_cinder_config('pure/san_ip').with_value('127.0.0.2')
      is_expected.to contain_cinder_config('pure/pure_api_token').with_value('abc123def456ghi789')
      is_expected.to contain_cinder_config('pure/use_multipath_for_image_xfer').with_value('true')
      is_expected.to contain_cinder_config('pure/use_chap_auth').with_value('true')
    end
  end

  describe 'pure fc volume driver' do
    let :params do
      req_params.merge({'pure_storage_protocol' => 'FC'})
    end

    it 'configure pure volume driver' do
      is_expected.to contain_cinder_config('pure/volume_driver').with_value('cinder.volume.drivers.pure.PureFCDriver')
      is_expected.to contain_cinder_config('pure/san_ip').with_value('127.0.0.2')
      is_expected.to contain_cinder_config('pure/pure_api_token').with_value('abc123def456ghi789')
      is_expected.to contain_cinder_config('pure/use_multipath_for_image_xfer').with_value('true')
      is_expected.to contain_cinder_config('pure/use_chap_auth').with_value('false')
    end
  end

  describe 'pure volume driver with additional configuration' do
    let :params do
      req_params.merge({:extra_options => {'pure_backend/param1' => {'value' => 'value1'}}})
    end

    it 'configure pure volume with additional configuration' do
      is_expected.to contain_cinder__backend__pure('pure').with({
        :extra_options => {'pure_backend/param1' => {'value' => 'value1'}}
      })
    end
  end

  describe 'pure backend with cinder type' do
    let :params do
      req_params.merge!({:manage_volume_type => true})
    end
    it 'should create type with properties' do
      should contain_cinder_type('pure').with(:ensure => :present, :properties => ['volume_backend_name=pure'])
    end
  end

end
