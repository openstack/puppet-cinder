require 'spec_helper'

describe 'cinder::backend::dellemc_powerflex' do
  let (:title) { 'powerflex' }

  let :params1 do
    {
      :san_login                  => 'admin',
      :san_password               => 'password',
      :san_ip                     => 'powerflex.example.com',
      :powerflex_rest_server_port => '443',
      :manage_volume_type         => true,
      :san_thin_provision         => false,
    }
  end

  let :params2 do
    {
      :backend_availability_zone                => 'my_zone',
      :powerflex_allow_migration_during_rebuild => 'true',
      :powerflex_allow_non_padded_volumes       => 'false',
      :powerflex_max_over_subscription_ratio    => '6.0',
      :powerflex_round_volume_capacity          => true,
      :powerflex_server_api_version             => '3.5',
      :powerflex_storage_pools                  => 'domain1:pool1,domain2:pool2',
      :powerflex_unmap_volume_before_deletion   => false,
      :driver_ssl_cert_path                     => '/path/cert.pem',
      :driver_ssl_cert_verify                   => true,
    }
  end

  let :params do
    params1.merge(params2)
  end

  shared_examples 'cinder::backend::dellemc_powerflex' do
    context 'powerflex volume driver' do
      it { is_expected.to contain_cinder_config("#{title}/volume_driver").with(
        :value => 'cinder.volume.drivers.dell_emc.powerflex.driver.PowerFlexDriver'
      )}

      it {
        is_expected.to contain_cinder_config("#{title}/san_login").with_value('admin')
        is_expected.to contain_cinder_config("#{title}/san_ip").with_value('powerflex.example.com')
        is_expected.to contain_cinder_config("#{title}/san_thin_provision").with_value('false')
        is_expected.to contain_cinder_config("#{title}/powerflex_rest_server_port").with_value('443')
      }

      it {
        params2.each_pair do |config,value|
          is_expected.to contain_cinder_config("#{title}/#{config}").with_value(value)
        end
      }

      it { is_expected.to contain_cinder_config("#{title}/san_password").with_secret(true) }
    end

    context 'powerflex backend with additional configuration' do
      before :each do
        params.merge!( :extra_options => {"#{title}/param1" => {'value' => 'value1'}} )
      end

      it { is_expected.to contain_cinder_config("#{title}/param1").with_value('value1') }
    end

    context 'powerflex backend with cinder type' do
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

      it_behaves_like 'cinder::backend::dellemc_powerflex'
    end
  end
end
