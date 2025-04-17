#
# Unit tests for cinder::keystone::auth
#

require 'spec_helper'

describe 'cinder::keystone::auth' do
  shared_examples_for 'cinder::keystone::auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'cinder_password' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('cinder').with(
        :configure_user      => true,
        :configure_user_role => true,
        :configure_endpoint  => true,
        :configure_service   => true,
        :service_name        => 'cinder',
        :service_type        => 'block-storage',
        :service_description => 'OpenStack Block Storage Service',
        :region              => 'RegionOne',
        :auth_name           => 'cinder',
        :password            => 'cinder_password',
        :email               => 'cinder@localhost',
        :tenant              => 'services',
        :roles               => ['admin'],
        :system_scope        => 'all',
        :system_roles        => [],
        :public_url          => 'http://127.0.0.1:8776/v3',
        :internal_url        => 'http://127.0.0.1:8776/v3',
        :admin_url           => 'http://127.0.0.1:8776/v3',
      ) }

      it { is_expected.to contain_keystone__resource__service_identity('cinderv3').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => true,
        :configure_service   => true,
        :service_name        => 'cinderv3',
        :service_type        => 'volumev3',
        :service_description => 'Cinder Service v3',
        :region              => 'RegionOne',
        :public_url          => 'http://127.0.0.1:8776/v3',
        :internal_url        => 'http://127.0.0.1:8776/v3',
        :admin_url           => 'http://127.0.0.1:8776/v3',
      ) }
    end

    context 'when overriding parameters' do
      let :params do
        { :password               => 'cinder_password',
          :auth_name              => 'alt_cinder',
          :email                  => 'alt_cinder@alt_localhost',
          :tenant                 => 'alt_service',
          :roles                  => ['admin', 'service'],
          :system_scope           => 'alt_all',
          :system_roles           => ['admin', 'member', 'reader'],
          :configure_user         => false,
          :configure_user_role    => false,
          :service_description    => 'Alternative OpenStack Block Storage Service',
          :service_description_v3 => 'Alternative Cinder Service v3',
          :service_name           => 'alt_service',
          :service_name_v3        => 'alt_servicev3',
          :service_type           => 'alt_block-storage',
          :service_type_v3        => 'alt_volumev3',
          :region                 => 'RegionTwo',
          :public_url_v3          => 'https://10.10.10.10:80',
          :internal_url_v3        => 'http://10.10.10.11:81',
          :admin_url_v3           => 'http://10.10.10.12:81',
          :configure_endpoint     => false,
          :configure_endpoint_v3  => false,
          :configure_service      => false,
          :configure_service_v3   => false
        }
      end

      it { is_expected.to contain_keystone__resource__service_identity('cinder').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => false,
        :configure_service   => false,
        :service_name        => 'alt_service',
        :service_type        => 'alt_block-storage',
        :service_description => 'Alternative OpenStack Block Storage Service',
        :region              => 'RegionTwo',
        :auth_name           => 'alt_cinder',
        :password            => 'cinder_password',
        :email               => 'alt_cinder@alt_localhost',
        :tenant              => 'alt_service',
        :roles               => ['admin', 'service'],
        :system_scope        => 'alt_all',
        :system_roles        => ['admin', 'member', 'reader'],
        :public_url          => 'https://10.10.10.10:80',
        :internal_url        => 'http://10.10.10.11:81',
        :admin_url           => 'http://10.10.10.12:81',
      ) }

      it { is_expected.to contain_keystone__resource__service_identity('cinderv3').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => false,
        :configure_service   => false,
        :service_name        => 'alt_servicev3',
        :service_type        => 'alt_volumev3',
        :service_description => 'Alternative Cinder Service v3',
        :region              => 'RegionTwo',
        :public_url          => 'https://10.10.10.10:80',
        :internal_url        => 'http://10.10.10.11:81',
        :admin_url           => 'http://10.10.10.12:81',
      ) }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder::keystone::auth'
    end
  end
end
