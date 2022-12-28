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
        is_expected.to contain_cinder_config('pure/image_volume_cache_enabled').with_value('true')
        is_expected.to contain_cinder_config('pure/pure_eradicate_on_delete').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('pure/pure_iscsi_cidr').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('pure/pure_iscsi_cidr_list').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('pure/pure_host_personality').with_value('<SERVICE DEFAULT>')
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
        is_expected.to contain_cinder_config('pure/pure_eradicate_on_delete').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('pure/pure_iscsi_cidr').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('pure/pure_iscsi_cidr_list').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('pure/pure_host_personality').with_value('<SERVICE DEFAULT>')
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
        is_expected.to contain_cinder_config('pure/pure_eradicate_on_delete').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('pure/pure_host_personality').with_value('<SERVICE DEFAULT>')
      }
    end

    context 'pure nvme volume driver' do
      let :params do
        req_params.merge({'pure_storage_protocol' => 'NVMe'})
      end

      it {
        is_expected.to contain_cinder_config('pure/volume_driver').with_value('cinder.volume.drivers.pure.PureNVMEDriver')
        is_expected.to contain_cinder_config('pure/san_ip').with_value('127.0.0.2')
        is_expected.to contain_cinder_config('pure/pure_api_token').with_value('abc123def456ghi789')
        is_expected.to contain_cinder_config('pure/use_multipath_for_image_xfer').with_value('true')
        is_expected.to contain_cinder_config('pure/use_chap_auth').with_value('false')
        is_expected.to contain_cinder_config('pure/pure_eradicate_on_delete').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('pure/pure_nvme_cidr').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('pure/pure_nvme_transport').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('pure/pure_host_personality').with_value('<SERVICE DEFAULT>')
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

    context 'pure volume driver with image_volume_cache_enabled disabled' do
      let :params do
        req_params.merge({'image_volume_cache_enabled' => false})
      end

      it {
        is_expected.to contain_cinder_config('pure/image_volume_cache_enabled').with_value('false')
      }
    end

    context 'pure volume driver with pure_nvme_cidr_list set to an array' do
      let :params do
        req_params.merge({'pure_nvme_cidr_list' => ['192.0.3.1/24', '192.0.3.2/24']})
      end

      it {
        is_expected.to contain_cinder_config('pure/pure_nvme_cidr_list').with_value('192.0.3.1/24,192.0.3.2/24')
      }
    end

    context 'pure volume driver with pure_host_personality set' do
      let :params do
        req_params.merge({'pure_host_personality' => 'oracle-vm-server'})
      end

      it {
        is_expected.to contain_cinder_config('pure/pure_host_personality').with_value('oracle-vm-server')
      }
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
