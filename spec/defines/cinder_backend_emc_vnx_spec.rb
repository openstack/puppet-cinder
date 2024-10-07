require 'spec_helper'

describe 'cinder::backend::emc_vnx' do
  let (:title) { 'emc' }

  let :req_params do
    {
      :san_ip                 => '127.0.0.2',
      :san_login              => 'emc',
      :san_password           => 'password',
      :storage_vnx_pool_names => 'emc-storage-pool'
    }
  end

  let :params do
    req_params
  end

  shared_examples 'cinder::backend::emc_vnx' do
    context 'emc vnx volume driver' do
      it {
        is_expected.to contain_cinder_config('emc/volume_driver').with_value('cinder.volume.drivers.dell_emc.vnx.driver.VNXDriver')
        is_expected.to contain_cinder_config('emc/storage_protocol').with_value('iscsi')
        is_expected.to contain_cinder_config('emc/san_ip').with_value('127.0.0.2')
        is_expected.to contain_cinder_config('emc/san_login').with_value('emc')
        is_expected.to contain_cinder_config('emc/san_password').with_value('password').with_secret(true)
        is_expected.to contain_cinder_config('emc/storage_vnx_pool_names').with_value('emc-storage-pool')
        is_expected.to contain_cinder_config('emc/destroy_empty_storage_group').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('emc/iscsi_initiators').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('emc/io_port_list').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('emc/initiator_auto_registration').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('emc/initiator_auto_deregistration').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('emc/force_delete_lun_in_storagegroup').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('emc/ignore_pool_full_threshold').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('emc/vnx_async_migrate').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('emc/storage_vnx_authentication_type').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('emc/storage_vnx_security_file_dir').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('emc/naviseccli_path').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('emc/backend_availability_zone').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('emc/image_volume_cache_enabled').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('emc/image_volume_cache_max_size_gb').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('emc/image_volume_cache_max_count').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('emc/reserved_percentage').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('emc/max_over_subscription_ratio').with_value('<SERVICE DEFAULT>')
      }
    end

    context 'emc vnx backend overriding some parameters' do
      before :each do
        params.merge!({
          :storage_vnx_pool_names           => ['emc-storage-pool1', 'emc-storage-pool2'],
          :destroy_empty_storage_group      => false,
          :iscsi_initiators                 => '{"host1":["10.0.0.1", "10.0.0.2"]}',
          :io_port_list                     => ['a-1', 'B-3'],
          :initiator_auto_registration      => true,
          :initiator_auto_deregistration    => false,
          :force_delete_lun_in_storagegroup => false,
          :ignore_pool_full_threshold       => false,
          :vnx_async_migrate                => true,
          :storage_vnx_auth_type            => 'global',
          :storage_vnx_security_file_dir    => '/etc/secfile/array1',
          :naviseccli_path                  => '/opt/Navisphere/bin/naviseccli',
          :manage_volume_type               => true,
          :storage_protocol                 => 'fc',
          :backend_availability_zone        => 'my_zone',
          :image_volume_cache_enabled       => true,
          :image_volume_cache_max_size_gb   => 100,
          :image_volume_cache_max_count     => 101,
          :reserved_percentage              => 10,
          :max_over_subscription_ratio      => 1.5,
        })
      end

      it {
        is_expected.to contain_cinder_config('emc/storage_vnx_pool_names').with_value(params[:storage_vnx_pool_names].join(','))
        is_expected.to contain_cinder_config('emc/destroy_empty_storage_group').with_value(params[:destroy_empty_storage_group])
        is_expected.to contain_cinder_config('emc/iscsi_initiators').with_value(params[:iscsi_initiators])
        is_expected.to contain_cinder_config('emc/io_port_list').with_value(params[:io_port_list].join(','))
        is_expected.to contain_cinder_config('emc/initiator_auto_registration').with_value(params[:initiator_auto_registration])
        is_expected.to contain_cinder_config('emc/initiator_auto_deregistration').with_value(params[:initiator_auto_deregistration])
        is_expected.to contain_cinder_config('emc/force_delete_lun_in_storagegroup').with_value(params[:force_delete_lun_in_storagegroup])
        is_expected.to contain_cinder_config('emc/ignore_pool_full_threshold').with_value(params[:ignore_pool_full_threshold])
        is_expected.to contain_cinder_config('emc/vnx_async_migrate').with_value(params[:vnx_async_migrate])
        is_expected.to contain_cinder_config('emc/storage_vnx_authentication_type').with_value(params[:storage_vnx_auth_type])
        is_expected.to contain_cinder_config('emc/storage_vnx_security_file_dir').with_value(params[:storage_vnx_security_file_dir])
        is_expected.to contain_cinder_config('emc/naviseccli_path').with_value(params[:naviseccli_path])
        is_expected.to contain_cinder_config('emc/storage_protocol').with_value(params[:storage_protocol])
        is_expected.to contain_cinder_config('emc/backend_availability_zone').with_value(params[:backend_availability_zone])
        is_expected.to contain_cinder_config('emc/image_volume_cache_enabled').with_value(params[:image_volume_cache_enabled])
        is_expected.to contain_cinder_config('emc/image_volume_cache_max_size_gb').with_value(params[:image_volume_cache_max_size_gb])
        is_expected.to contain_cinder_config('emc/image_volume_cache_max_count').with_value(params[:image_volume_cache_max_count])
        is_expected.to contain_cinder_config('emc/reserved_percentage').with_value(params[:reserved_percentage])
        is_expected.to contain_cinder_config('emc/max_over_subscription_ratio').with_value(1.5)
      }

      it { is_expected.to contain_cinder_type('emc').with(
        :ensure     => 'present',
        :properties => {'volume_backend_name' => 'emc'}
      )}
    end

    context 'emc vnx backend with additional configuration' do
      before :each do
        params.merge!( :extra_options => {'emc/param1' => {'value' => 'value1'}} )
      end

      it { is_expected.to contain_cinder_config('emc/param1').with_value('value1') }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder::backend::emc_vnx'
    end
  end
end
