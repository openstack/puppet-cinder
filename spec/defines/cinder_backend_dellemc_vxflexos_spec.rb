require 'spec_helper'

describe 'cinder::backend::dellemc_vxflexos' do
  let (:title) { 'vxflexos' }

  let :params1 do
    {
      :san_login                 => 'admin',
      :san_password              => 'password',
      :san_ip                    => 'vxflexos.example.com',
      :vxflexos_rest_server_port => '443',
      :manage_volume_type        => true,
      :san_thin_provision        => false,
    }
  end

  let :params2 do
    {
      :backend_availability_zone               => 'my_zone',
      :vxflexos_allow_migration_during_rebuild => 'true',
      :vxflexos_allow_non_padded_volumes       => 'false',
      :vxflexos_max_over_subscription_ratio    => '6.0',
      :vxflexos_round_volume_capacity          => true,
      :vxflexos_server_api_version             => '3.5',
      :vxflexos_storage_pools                  => 'domain1:pool1,domain2:pool2',
      :vxflexos_unmap_volume_before_deletion   => false,
      :driver_ssl_cert_path                    => '/path/cert.pem',
      :driver_ssl_cert_verify                  => true,
    }
  end

  let :params do
    params1.merge(params2)
  end

  shared_examples 'cinder::backend::dellemc_vxflexos' do
    context 'vxflexos volume driver' do
      it { is_expected.to contain_cinder_config("#{title}/volume_driver").with(
        :value => 'cinder.volume.drivers.dell_emc.vxflexos.driver.VxFlexOSDriver'
      )}

      it {
        is_expected.to contain_cinder_config("#{title}/san_login").with_value('admin')
        is_expected.to contain_cinder_config("#{title}/san_ip").with_value('vxflexos.example.com')
        is_expected.to contain_cinder_config("#{title}/san_thin_provision").with_value('false')
        is_expected.to contain_cinder_config("#{title}/vxflexos_rest_server_port").with_value('443')
      }

      it {
        params2.each_pair do |config,value|
          is_expected.to contain_cinder_config("#{title}/#{config}").with_value(value)
        end
      }

      it { is_expected.to contain_cinder_config("#{title}/san_password").with_secret(true) }
    end

    context 'vxflexos backend with additional configuration' do
      before :each do
        params.merge!( :extra_options => {"#{title}/param1" => {'value' => 'value1'}} )
      end

      it { is_expected.to contain_cinder_config("#{title}/param1").with_value('value1') }
    end

    context 'vxflexos backend with cinder type' do
      before :each do
        params.merge!( :manage_volume_type => true )
      end

      it { is_expected.to contain_cinder_type("#{title}").with(
        :ensure     => 'present',
        :properties => ["volume_backend_name=#{title}"]
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

      it_behaves_like 'cinder::backend::dellemc_vxflexos'
    end
  end
end
