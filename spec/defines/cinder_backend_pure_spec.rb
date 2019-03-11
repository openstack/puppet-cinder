require 'spec_helper'

describe 'cinder::backend::pure' do
  let (:title) { 'pure' }

  let :req_params do
    {
      :san_ip            => '127.0.0.2',
      :pure_api_token    => 'abc123def456ghi789'
    }
  end

  shared_examples 'cinder::backend::pure' do
    context 'pure volume driver defaults' do
      let :params do
        req_params
      end

      it {
        is_expected.to contain_cinder_config('pure/volume_driver').with_value('cinder.volume.drivers.pure.PureISCSIDriver')
        is_expected.to contain_cinder_config('pure/san_ip').with_value('127.0.0.2')
        is_expected.to contain_cinder_config('pure/pure_api_token').with_value('abc123def456ghi789')
        is_expected.to contain_cinder_config('pure/use_multipath_for_image_xfer').with_value('true')
        is_expected.to contain_cinder_config('pure/use_chap_auth').with_value('false')
      }
    end

    context 'pure iscsi volume driver' do
      let :params do
        req_params.merge({
          :backend_availability_zone => 'my_zone',
          :pure_storage_protocol     => 'iSCSI',
          :use_chap_auth             => 'true',
        })
      end

      it {
        is_expected.to contain_cinder_config('pure/volume_driver').with_value('cinder.volume.drivers.pure.PureISCSIDriver')
        is_expected.to contain_cinder_config('pure/backend_availability_zone').with_value('my_zone')
        is_expected.to contain_cinder_config('pure/san_ip').with_value('127.0.0.2')
        is_expected.to contain_cinder_config('pure/pure_api_token').with_value('abc123def456ghi789')
        is_expected.to contain_cinder_config('pure/use_multipath_for_image_xfer').with_value('true')
        is_expected.to contain_cinder_config('pure/use_chap_auth').with_value('true')
      }
    end

    context 'pure fc volume driver' do
      let :params do
        req_params.merge({'pure_storage_protocol' => 'FC'})
      end

      it {
        is_expected.to contain_cinder_config('pure/volume_driver').with_value('cinder.volume.drivers.pure.PureFCDriver')
        is_expected.to contain_cinder_config('pure/san_ip').with_value('127.0.0.2')
        is_expected.to contain_cinder_config('pure/pure_api_token').with_value('abc123def456ghi789')
        is_expected.to contain_cinder_config('pure/use_multipath_for_image_xfer').with_value('true')
        is_expected.to contain_cinder_config('pure/use_chap_auth').with_value('false')
      }
    end

    context 'pure volume driver with additional configuration' do
      let :params do
        req_params.merge({:extra_options => {'pure_backend/param1' => {'value' => 'value1'}}})
      end

      it { is_expected.to contain_cinder__backend__pure('pure').with(
        :extra_options => {'pure_backend/param1' => {'value' => 'value1'}}
      )}
    end

    context 'pure backend with cinder type' do
      let :params do
        req_params.merge!({:manage_volume_type => true})
      end

      it { is_expected.to contain_cinder_type('pure').with(
        :ensure     => 'present',
        :properties => ['volume_backend_name=pure']
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

      it_behaves_like 'cinder::backend::pure'
    end
  end
end
