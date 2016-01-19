require 'spec_helper'

describe 'cinder::api' do

  shared_examples_for 'cinder api' do
    let :req_params do
      {:keystone_password => 'foo'}
    end

    describe 'with only required params' do
      let :params do
        req_params
      end

      it { is_expected.to contain_service('cinder-api').with(
        'hasstatus' => true,
        'ensure' => 'running',
        'tag' => 'cinder-service',
      )}

      it 'should configure cinder api correctly' do
        is_expected.to contain_cinder_config('DEFAULT/auth_strategy').with(
         :value => 'keystone'
        )
        is_expected.to contain_cinder_config('DEFAULT/osapi_volume_listen').with(
         :value => '0.0.0.0'
        )
        is_expected.to contain_cinder_config('DEFAULT/osapi_volume_workers').with(
         :value => '8'
        )
        is_expected.to contain_cinder_config('DEFAULT/nova_catalog_info').with(
         :value => 'compute:Compute Service:publicURL'
        )
        is_expected.to contain_cinder_config('DEFAULT/nova_catalog_admin_info').with(
         :value => 'compute:Compute Service:adminURL'
        )
        is_expected.to contain_cinder_config('DEFAULT/default_volume_type').with(
         :value => '<SERVICE DEFAULT>'
        )
        is_expected.to contain_cinder_config('DEFAULT/os_region_name').with(
         :value => '<SERVICE DEFAULT>'
        )
        is_expected.to contain_cinder_config('keystone_authtoken/auth_uri').with(
         :value => 'http://localhost:5000/'
        )
        is_expected.to contain_cinder_config('keystone_authtoken/identity_uri').with(
         :value => 'http://localhost:35357/'
        )
        is_expected.to contain_cinder_config('keystone_authtoken/admin_tenant_name').with(
         :value => 'services'
        )
        is_expected.to contain_cinder_config('keystone_authtoken/admin_user').with(
         :value => 'cinder'
        )
        is_expected.to contain_cinder_config('keystone_authtoken/admin_password').with(
         :value => 'foo'
        )

        is_expected.to contain_cinder_config('DEFAULT/os_privileged_user_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/os_privileged_user_password').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/os_privileged_user_tenant').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/os_privileged_user_auth_url').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('keymgr/encryption_auth_url').with_value('<SERVICE DEFAULT>')
      end
    end

    describe 'with a custom nova_catalog params' do
      let :params do
        req_params.merge({
          'nova_catalog_admin_info' => 'compute:nova:adminURL',
          'nova_catalog_info' => 'compute:nova:publicURL',
        })
      end
      it { is_expected.to contain_cinder_config('DEFAULT/nova_catalog_admin_info').with_value('compute:nova:adminURL') }
      it { is_expected.to contain_cinder_config('DEFAULT/nova_catalog_info').with_value('compute:nova:publicURL') }
    end

    describe 'with a custom region for nova' do
      let :params do
        req_params.merge({'os_region_name' => 'MyRegion'})
      end
      it 'should configure the region for nova' do
        is_expected.to contain_cinder_config('DEFAULT/os_region_name').with(
          :value => 'MyRegion'
        )
      end
    end

    describe 'with an OpenStack privileged account' do

      context 'with all needed params' do
        let :params do
          req_params.merge({
            'privileged_user'             => 'true',
            'os_privileged_user_name'     => 'admin',
            'os_privileged_user_password' => 'password',
            'os_privileged_user_tenant'   => 'admin',
            'os_privileged_user_auth_url' => 'http://localhost:8080',
          })
        end

        it { is_expected.to contain_cinder_config('DEFAULT/os_privileged_user_name').with_value('admin') }
        it { is_expected.to contain_cinder_config('DEFAULT/os_privileged_user_password').with_value('password') }
        it { is_expected.to contain_cinder_config('DEFAULT/os_privileged_user_tenant').with_value('admin') }
        it { is_expected.to contain_cinder_config('DEFAULT/os_privileged_user_auth_url').with_value('http://localhost:8080') }
      end

      context 'without os_privileged_user_auth_url' do
        let :params do
          req_params.merge({
            'privileged_user'             => 'true',
            'os_privileged_user_name'     => 'admin',
            'os_privileged_user_password' => 'password',
            'os_privileged_user_tenant'   => 'admin',
          })
        end

        it { is_expected.to contain_cinder_config('DEFAULT/os_privileged_user_name').with_value('admin') }
        it { is_expected.to contain_cinder_config('DEFAULT/os_privileged_user_password').with_value('password') }
        it { is_expected.to contain_cinder_config('DEFAULT/os_privileged_user_tenant').with_value('admin') }
        it { is_expected.to contain_cinder_config('DEFAULT/os_privileged_user_auth_url').with_value('<SERVICE DEFAULT>') }
      end

      context 'without os_privileged_user' do
        let :params do
          req_params.merge({
            'privileged_user' => 'true',
          })
        end

        it_raises 'a Puppet::Error', /The os_privileged_user_name parameter is required when privileged_user is set to true/
      end

      context 'without os_privileged_user_password' do
        let :params do
          req_params.merge({
            'privileged_user'         => 'true',
            'os_privileged_user_name' => 'admin',
          })
        end

        it_raises 'a Puppet::Error', /The os_privileged_user_password parameter is required when privileged_user is set to true/
      end

      context 'without os_privileged_user_tenant' do
        let :params do
          req_params.merge({
            'privileged_user'             => 'true',
            'os_privileged_user_name'     => 'admin',
            'os_privileged_user_password' => 'password',
          })
        end

        it_raises 'a Puppet::Error', /The os_privileged_user_tenant parameter is required when privileged_user is set to true/
      end
    end

    describe 'with a default volume type' do
      let :params do
        req_params.merge({'default_volume_type' => 'foo'})
      end
      it 'should configure the default volume type for cinder' do
        is_expected.to contain_cinder_config('DEFAULT/default_volume_type').with(
          :value => 'foo'
        )
      end
    end

    describe 'with only required params' do
      let :params do
        req_params.merge({'bind_host' => '192.168.1.3'})
      end
      it 'should configure cinder api correctly' do
        is_expected.to contain_cinder_config('DEFAULT/osapi_volume_listen').with(
         :value => '192.168.1.3'
        )
      end
    end

    describe 'with sync_db set to false' do
      let :params do
        {
          :keystone_password => 'dummy',
          :enabled           => 'true',
          :sync_db           => false,
        }
      end
      it { is_expected.not_to contain_class('cinder::db::sync') }
    end

    describe 'with enabled false' do
      let :params do
        req_params.merge({'enabled' => false})
      end
      it 'should stop the service' do
        is_expected.to contain_service('cinder-api').with_ensure('stopped')
      end
      it 'includes cinder::db::sync' do
        is_expected.to contain_class('cinder::db::sync')
      end
    end

    describe 'with manage_service false' do
      let :params do
        req_params.merge({'manage_service' => false})
      end
      it 'should not change the state of the service' do
        is_expected.to contain_service('cinder-api').without_ensure
      end
      it 'includes cinder::db::sync' do
        is_expected.to contain_class('cinder::db::sync')
      end
    end

    describe 'with ratelimits' do
      let :params do
        req_params.merge({ :ratelimits => '(GET, "*", .*, 100, MINUTE);(POST, "*", .*, 200, MINUTE)' })
      end

      it { is_expected.to contain_cinder_api_paste_ini('filter:ratelimit/limits').with(
        :value => '(GET, "*", .*, 100, MINUTE);(POST, "*", .*, 200, MINUTE)'
      )}
    end

    describe 'with encryption_auth_url' do
      let :params do
        req_params.merge({ :keymgr_encryption_auth_url => 'http://localhost:5000/v3' })
      end

      it { is_expected.to contain_cinder_config('keymgr/encryption_auth_url').with(
        :value => 'http://localhost:5000/v3'
      )}
    end

    describe 'while validating the service with default command' do
      let :params do
        req_params.merge({
          :validate => true,
        })
      end
      it { is_expected.to contain_exec('execute cinder-api validation').with(
        :path        => '/usr/bin:/bin:/usr/sbin:/sbin',
        :provider    => 'shell',
        :tries       => '10',
        :try_sleep   => '2',
        :command     => 'cinder --os-auth-url http://localhost:5000/ --os-tenant-name services --os-username cinder --os-password foo list',
      )}

      it { is_expected.to contain_anchor('create cinder-api anchor').with(
        :require => 'Exec[execute cinder-api validation]',
      )}
    end

    describe 'while validating the service with custom command' do
      let :params do
        req_params.merge({
          :validate            => true,
          :validation_options  => { 'cinder-api' => { 'command' => 'my-script' } }
        })
      end
      it { is_expected.to contain_exec('execute cinder-api validation').with(
        :path        => '/usr/bin:/bin:/usr/sbin:/sbin',
        :provider    => 'shell',
        :tries       => '10',
        :try_sleep   => '2',
        :command     => 'my-script',
      )}

      it { is_expected.to contain_anchor('create cinder-api anchor').with(
        :require => 'Exec[execute cinder-api validation]',
      )}
    end

    describe "with custom keystone identity_uri and auth_uri" do
      let :params do
        req_params.merge({
          :identity_uri         => 'https://localhost:35357/',
          :auth_uri             => 'https://localhost:5000/',
        })
      end
      it 'configures identity_uri and auth_uri but deprecates old auth settings' do
        is_expected.to contain_cinder_config('keystone_authtoken/identity_uri').with_value("https://localhost:35357/")
        is_expected.to contain_cinder_config('keystone_authtoken/auth_uri').with_value("https://localhost:5000/")
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({:processorcount => 8}))
      end

      it_configures 'cinder api'
    end
  end
end
