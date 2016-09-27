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
        is_expected.to contain_cinder_config('DEFAULT/public_endpoint').with(
         :value => '<SERVICE DEFAULT>'
        )
        is_expected.to contain_cinder_config('DEFAULT/osapi_volume_base_URL').with(
         :value => '<SERVICE DEFAULT>'
        )
        is_expected.to contain_cinder_config('DEFAULT/osapi_max_limit').with(
         :value => '<SERVICE DEFAULT>'
        )
        is_expected.to contain_cinder_config('DEFAULT/os_region_name').with(
         :value => '<SERVICE DEFAULT>'
        )
        is_expected.to contain_cinder_config('keystone_authtoken/auth_uri').with(
         :value => 'http://localhost:5000'
        )
        is_expected.to contain_cinder_config('keystone_authtoken/auth_url').with(
         :value => 'http://localhost:35357'
        )
        is_expected.to contain_cinder_config('keystone_authtoken/project_name').with(
         :value => 'services'
        )
        is_expected.to contain_cinder_config('keystone_authtoken/username').with(
         :value => 'cinder'
        )
        is_expected.to contain_cinder_config('keystone_authtoken/password').with(
         :value => 'foo'
        )
        is_expected.to contain_cinder_config('keystone_authtoken/memcached_servers').with_value('<SERVICE DEFAULT>')

        is_expected.to contain_cinder_config('DEFAULT/os_privileged_user_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/os_privileged_user_password').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/os_privileged_user_tenant').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/os_privileged_user_auth_url').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('key_manager/api_class').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('barbican/barbican_endpoint').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('barbican/auth_endpoint').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_middleware/enable_proxy_headers_parsing').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/osapi_volume_listen_port').with('value' => '<SERVICE DEFAULT>')
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

    describe 'without deprecated keystone_authtoken parameters' do
      let :params do
        req_params.merge({
          'keystone_user'   => 'dummy',
          'keystone_tenant' => 'mytenant',
          'identity_uri'    => 'https://127.0.0.1:35357/deprecated',
          'auth_uri'        => 'https://127.0.0.1:5000/deprecated',
        })
      end

      it { is_expected.to contain_cinder_config('keystone_authtoken/auth_url').with_value('https://127.0.0.1:35357/deprecated') }
      it { is_expected.to contain_cinder_config('keystone_authtoken/username').with_value('dummy') }
      it { is_expected.to contain_cinder_config('keystone_authtoken/project_name').with_value('mytenant') }
      it { is_expected.to contain_cinder_config('keystone_authtoken/auth_uri').with_value('https://127.0.0.1:5000/deprecated') }
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

    describe 'with a customized port' do
      let :params do
        req_params.merge({'osapi_volume_listen_port' => 9999})
      end
      it 'should customize the port' do
        is_expected.to contain_cinder_config('DEFAULT/osapi_volume_listen_port').with(
          :value => 9999
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
          :enabled           => true,
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

      it { is_expected.to contain_cinder_config('barbican/auth_endpoint').with(
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
        :command     => 'cinder --os-auth-url http://localhost:5000 --os-project-name services --os-username cinder --os-password foo list',
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

    describe "with deprecated memcached servers for keystone authtoken" do
      let :params do
        req_params.merge({
          :memcached_servers => '1.1.1.1:11211',
        })
      end
      it 'configures memcached servers' do
        is_expected.to contain_cinder_config('keystone_authtoken/memcached_servers').with_value('1.1.1.1:11211')
      end
    end

    describe 'with a custom osapi_max_limit' do
      let :params do
        req_params.merge({'osapi_max_limit' => '10000'})
      end
      it 'should configure the osapi_max_limit to 10000' do
        is_expected.to contain_cinder_config('DEFAULT/osapi_max_limit').with(
          :value => '10000'
        )
      end
    end
    describe 'when running cinder-api in wsgi' do
      let :params do
        req_params.merge!({ :service_name   => 'httpd' })
      end

      let :pre_condition do
        "include ::apache
         class { 'cinder': rabbit_password => 'secret' }"
      end

      it 'configures cinder-api service with Apache' do
        is_expected.to contain_service('cinder-api').with(
          :ensure     => 'stopped',
          :enable     => false,
          :tag        => ['cinder-service'],
        )
      end
    end

    describe 'when service_name is not valid' do
      let :params do
        req_params.merge!({ :service_name   => 'foobar' })
      end

      let :pre_condition do
        "include ::apache
         class { 'cinder': rabbit_password => 'secret' }"
      end

      it_raises 'a Puppet::Error', /Invalid service_name/
    end

    describe 'with SSL socket options set' do
      let :params do
        req_params.merge!({
          :use_ssl         => true,
          :cert_file       => '/path/to/cert',
          :ca_file         => '/path/to/ca',
          :key_file        => '/path/to/key',
        })
      end

      it { is_expected.to contain_cinder_config('ssl/ca_file').with_value('/path/to/ca') }
      it { is_expected.to contain_cinder_config('ssl/cert_file').with_value('/path/to/cert') }
      it { is_expected.to contain_cinder_config('ssl/key_file').with_value('/path/to/key') }
    end

    describe 'with SSL socket options set wrongly configured' do
      let :params do
        req_params.merge!({
          :use_ssl         => true,
          :ca_file         => '/path/to/ca',
          :key_file        => '/path/to/key',
        })
      end

      it_raises 'a Puppet::Error', /The cert_file parameter is required when use_ssl is set to true/
    end

    describe 'with barbican parameters' do
      let :params do
        req_params.merge!({
          :keymgr_api_class           => 'castellan.key_manager.barbican_key_manager.BarbicanKeyManager',
          :keymgr_encryption_api_url  => 'https://localhost:9311/v1',
          :keymgr_encryption_auth_url => 'https://localhost:5000/v3',
        })
      end
      it 'should set keymgr parameters' do
        is_expected.to contain_cinder_config('key_manager/api_class').with_value('castellan.key_manager.barbican_key_manager.BarbicanKeyManager')
        is_expected.to contain_cinder_config('barbican/barbican_endpoint').with_value('https://localhost:9311/v1')
        is_expected.to contain_cinder_config('barbican/auth_endpoint').with_value('https://localhost:5000/v3')
      end
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :processorcount => 8,
          :fqdn           => 'some.host.tld',
          :concat_basedir => '/var/lib/puppet/concat',
        }))
      end

      it_configures 'cinder api'
    end
  end
end
