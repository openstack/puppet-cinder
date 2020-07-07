require 'spec_helper'

describe 'cinder::api' do
  shared_examples 'cinder api' do
    let :pre_condition do
      "class { 'cinder::keystone::authtoken':
         password => 'foo',
      }"
    end

    let :req_params do
      {}
    end

    context 'with only required params' do
      let :params do
        req_params
      end

      it { is_expected.to contain_service('cinder-api').with(
        'hasstatus' => true,
        'ensure'    => 'running',
        'tag'       => 'cinder-service',
      )}

      it 'should configure cinder api correctly' do
        is_expected.to contain_cinder_config('DEFAULT/osapi_volume_listen').with_value('0.0.0.0')
        is_expected.to contain_cinder_config('DEFAULT/osapi_volume_workers').with_value('8')
        is_expected.to contain_cinder_config('DEFAULT/default_volume_type').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/public_endpoint').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/osapi_volume_base_URL').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/osapi_max_limit').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/auth_strategy').with_value('keystone')
        is_expected.to contain_cinder_config('DEFAULT/osapi_volume_listen_port').with('value' => '<SERVICE DEFAULT>')

        is_expected.to contain_oslo__middleware('cinder_config').with(
          :enable_proxy_headers_parsing => '<SERVICE DEFAULT>',
          :max_request_body_size        => '<SERVICE DEFAULT>',
        )
      end
    end

    context 'with a customized port' do
      let :params do
        req_params.merge({'osapi_volume_listen_port' => 9999})
      end
      it 'should customize the port' do
        is_expected.to contain_cinder_config('DEFAULT/osapi_volume_listen_port').with(
          :value => 9999
        )
      end
    end

    context 'with a default volume type' do
      let :params do
        req_params.merge({'default_volume_type' => 'foo'})
      end
      it 'should configure the default volume type for cinder' do
        is_expected.to contain_cinder_config('DEFAULT/default_volume_type').with(
          :value => 'foo'
        )
      end
    end

    context 'with only required params' do
      let :params do
        req_params.merge({'bind_host' => '192.168.1.3'})
      end
      it 'should configure cinder api correctly' do
        is_expected.to contain_cinder_config('DEFAULT/osapi_volume_listen').with(
         :value => '192.168.1.3'
        )
      end
    end

    context 'with sync_db set to false' do
      let :params do
        {
          :enabled => true,
          :sync_db => false,
        }
      end
      it { is_expected.not_to contain_class('cinder::db::sync') }
    end

    context 'with enabled false' do
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

    context 'with manage_service false' do
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

    context 'with ratelimits' do
      let :params do
        req_params.merge({ :ratelimits => '(GET, "*", .*, 100, MINUTE);(POST, "*", .*, 200, MINUTE)' })
      end

      it { is_expected.to contain_cinder_api_paste_ini('filter:ratelimit/limits').with(
        :value => '(GET, "*", .*, 100, MINUTE);(POST, "*", .*, 200, MINUTE)'
      )}
    end

    context 'while validating the service with default command' do
      let :params do
        req_params.merge({
          :validate => true,
        })
      end
      it { is_expected.to contain_openstacklib__service_validation('cinder-api').with(
        :command   => 'cinder --os-auth-url http://localhost:5000 --os-project-name services --os-username cinder --os-password foo list',
        :subscribe => 'Service[cinder-api]',
      )}
    end

    context 'with a custom auth_strategy' do
      let :params do
        req_params.merge({'auth_strategy' => 'noauth'})
      end
      it 'should configure the auth_strategy to noauth' do
        is_expected.to contain_cinder_config('DEFAULT/auth_strategy').with(
          :value => 'noauth'
        )
      end
    end

    context 'with a custom osapi_max_limit' do
      let :params do
        req_params.merge({'osapi_max_limit' => '10000'})
      end
      it 'should configure the osapi_max_limit to 10000' do
        is_expected.to contain_cinder_config('DEFAULT/osapi_max_limit').with(
          :value => '10000'
        )
      end
    end
    context 'when running cinder-api in wsgi' do
      let :params do
        req_params.merge!({ :service_name => 'httpd' })
      end

      let :pre_condition do
        "include apache
         class { 'cinder': }
         class { 'cinder::keystone::authtoken':
           password => 'foo',
         }"
      end

      it 'configures cinder-api service with Apache' do
        is_expected.to contain_service('cinder-api').with(
          :ensure => 'stopped',
          :enable => false,
          :tag    => ['cinder-service'],
        )
      end
    end

    context 'when service_name is not valid' do
      let :params do
        req_params.merge!({ :service_name => 'foobar' })
      end

      let :pre_condition do
        "include apache
         class { 'cinder': }
         class { 'cinder::keystone::authtoken':
           password => 'foo',
         }"
      end

      it_raises 'a Puppet::Error', /Invalid service_name/
    end

    context 'with SSL socket options set' do
      let :params do
        req_params.merge!({
          :use_ssl   => true,
          :cert_file => '/path/to/cert',
          :ca_file   => '/path/to/ca',
          :key_file  => '/path/to/key',
        })
      end

      it { is_expected.to contain_cinder_config('ssl/ca_file').with_value('/path/to/ca') }
      it { is_expected.to contain_cinder_config('ssl/cert_file').with_value('/path/to/cert') }
      it { is_expected.to contain_cinder_config('ssl/key_file').with_value('/path/to/key') }
    end

    context 'with SSL socket options set wrongly configured' do
      let :params do
        req_params.merge!({
          :use_ssl  => true,
          :ca_file  => '/path/to/ca',
          :key_file => '/path/to/key',
        })
      end

      it_raises 'a Puppet::Error', /The cert_file parameter is required when use_ssl is set to true/
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :os_workers     => 8,
          :fqdn           => 'some.host.tld',
          :concat_basedir => '/var/lib/puppet/concat',
        }))
      end

      it_behaves_like 'cinder api'
    end
  end
end
