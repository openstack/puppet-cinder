require 'spec_helper'

describe 'cinder' do
  let :req_params do
    {
      :lock_path => '/var/lock/cinder',
    }
  end

  shared_examples 'cinder' do
    context 'with only required params' do
      let :params do
        req_params
      end

      it { is_expected.to contain_class('cinder::params') }

      it { is_expected.to contain_resources('cinder_config').with_purge(false) }

      it {
        is_expected.to contain_oslo__messaging__default('cinder_config').with(
          :transport_url        => '<SERVICE DEFAULT>',
          :rpc_response_timeout => '<SERVICE DEFAULT>',
          :control_exchange     => '<SERVICE DEFAULT>'
        )
        is_expected.to contain_oslo__messaging__rabbit('cinder_config').with(
          :rabbit_use_ssl              => '<SERVICE DEFAULT>',
          :heartbeat_timeout_threshold => '<SERVICE DEFAULT>',
          :heartbeat_rate              => '<SERVICE DEFAULT>',
          :heartbeat_in_pthread        => '<SERVICE DEFAULT>',
          :kombu_reconnect_delay       => '<SERVICE DEFAULT>',
          :kombu_failover_strategy     => '<SERVICE DEFAULT>',
          :amqp_durable_queues         => '<SERVICE DEFAULT>',
          :kombu_compression           => '<SERVICE DEFAULT>',
          :kombu_ssl_ca_certs          => '<SERVICE DEFAULT>',
          :kombu_ssl_certfile          => '<SERVICE DEFAULT>',
          :kombu_ssl_keyfile           => '<SERVICE DEFAULT>',
          :kombu_ssl_version           => '<SERVICE DEFAULT>',
          :rabbit_ha_queues            => '<SERVICE DEFAULT>',
          :rabbit_retry_interval       => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_oslo__messaging__amqp('cinder_config').with(
          :server_request_prefix => '<SERVICE DEFAULT>',
          :broadcast_prefix      => '<SERVICE DEFAULT>',
          :group_request_prefix  => '<SERVICE DEFAULT>',
          :container_name        => '<SERVICE DEFAULT>',
          :idle_timeout          => '<SERVICE DEFAULT>',
          :trace                 => '<SERVICE DEFAULT>',
          :ssl_ca_file           => '<SERVICE DEFAULT>',
          :ssl_cert_file         => '<SERVICE DEFAULT>',
          :ssl_key_file          => '<SERVICE DEFAULT>',
          :sasl_mechanisms       => '<SERVICE DEFAULT>',
          :sasl_config_dir       => '<SERVICE DEFAULT>',
          :sasl_config_name      => '<SERVICE DEFAULT>',
          :username              => '<SERVICE DEFAULT>',
          :password              => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_oslo__messaging__notifications('cinder_config').with(
          :transport_url => '<SERVICE DEFAULT>',
          :driver        => '<SERVICE DEFAULT>',
          :topics        => '<SERVICE DEFAULT>'
        )
      }

      it {
        is_expected.to contain_cinder_config('DEFAULT/report_interval').with(:value => '<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/service_down_time').with(:value => '<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/storage_availability_zone').with(:value => 'nova')
        is_expected.to contain_cinder_config('DEFAULT/default_availability_zone').with(:value => 'nova')
        is_expected.to contain_cinder_config('DEFAULT/allow_availability_zone_fallback').with(:value => '<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/api_paste_config').with(:value => '/etc/cinder/api-paste.ini')
        is_expected.to contain_oslo__concurrency('cinder_config').with(
          :lock_path => '/var/lock/cinder'
        )
        is_expected.to contain_cinder_config('DEFAULT/image_conversion_dir').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/host').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/enable_new_services').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/enable_force_upload').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/cinder_internal_tenant_project_id').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/cinder_internal_tenant_user_id').with_value('<SERVICE DEFAULT>')

        # backend_host should not be written to DEFAULT section
        is_expected.not_to contain_cinder_config('DEFAULT/backend_host')
      }
    end

    context 'with enable ha queues' do
      let :params do
        req_params.merge(
          :rabbit_ha_queues => true
        )
      end

      it { is_expected.to contain_oslo__messaging__rabbit('cinder_config').with(
        :rabbit_ha_queues => true
      ) }
    end

    context 'with rabbitmq heartbeats' do
      let :params do
        req_params.merge(
          :rabbit_heartbeat_timeout_threshold => '60',
          :rabbit_heartbeat_rate              => '10',
          :rabbit_heartbeat_in_pthread        => true
        )
      end

      it { is_expected.to contain_oslo__messaging__rabbit('cinder_config').with(
        :heartbeat_timeout_threshold => '60',
        :heartbeat_rate              => '10',
        :heartbeat_in_pthread        => true,
      ) }
    end

    context 'with SSL enabled with kombu' do
      let :params do
        req_params.merge!({
          :rabbit_use_ssl     => true,
          :kombu_ssl_ca_certs => '/path/to/ssl/ca/certs',
          :kombu_ssl_certfile => '/path/to/ssl/cert/file',
          :kombu_ssl_keyfile  => '/path/to/ssl/keyfile',
          :kombu_ssl_version  => 'TLSv1'
        })
      end

      it { is_expected.to contain_oslo__messaging__rabbit('cinder_config').with(
        :rabbit_use_ssl     => true,
        :kombu_ssl_ca_certs => '/path/to/ssl/ca/certs',
        :kombu_ssl_certfile => '/path/to/ssl/cert/file',
        :kombu_ssl_keyfile  => '/path/to/ssl/keyfile',
        :kombu_ssl_version  => 'TLSv1'
      )}
    end

    context 'with SSL enabled without kombu' do
      let :params do
        req_params.merge!({
          :rabbit_use_ssl => true,
        })
      end

      it { is_expected.to contain_oslo__messaging__rabbit('cinder_config').with(
        :rabbit_use_ssl => true,
      )}
    end

    context 'with SSL disabled' do
      let :params do
        req_params.merge!({
          :rabbit_use_ssl     => false,
          :kombu_ssl_ca_certs => '<SERVICE DEFAULT>',
          :kombu_ssl_certfile => '<SERVICE DEFAULT>',
          :kombu_ssl_keyfile  => '<SERVICE DEFAULT>',
          :kombu_ssl_version  => '<SERVICE DEFAULT>'
        })
      end

      it { is_expected.to contain_oslo__messaging__rabbit('cinder_config').with(
        :rabbit_use_ssl     => false,
        :kombu_ssl_ca_certs => '<SERVICE DEFAULT>',
        :kombu_ssl_certfile => '<SERVICE DEFAULT>',
        :kombu_ssl_keyfile  => '<SERVICE DEFAULT>',
        :kombu_ssl_version  => '<SERVICE DEFAULT>'
      )}
    end

    context 'with different lock_path' do
      let :params do
        req_params.merge!( :lock_path => '/var/run/cinder.locks' )
      end

      it { is_expected.to contain_oslo__concurrency('cinder_config').with(
        :lock_path => '/var/run/cinder.locks'
      ) }
    end

    context 'with amqp_durable_queues enabled' do
      let :params do
        req_params.merge({
          :amqp_durable_queues => true,
        })
      end

      it { is_expected.to contain_oslo__messaging__rabbit('cinder_config').with(
        :amqp_durable_queues => true
      ) }
    end

    context 'with amqp overrides' do
      let :params do
      {
        :amqp_idle_timeout  => '60',
        :amqp_trace         => true,
        :amqp_ssl_ca_file   => '/path/to/ca.cert',
        :amqp_ssl_cert_file => '/path/to/certfile',
        :amqp_ssl_key_file  => '/path/to/key',
        :amqp_username      => 'amqp_user',
        :amqp_password      => 'password',
      }
      end

      it { is_expected.to contain_oslo__messaging__amqp('cinder_config').with(
        :idle_timeout  => '60',
        :trace         => true,
        :ssl_ca_file   => '/path/to/ca.cert',
        :ssl_cert_file => '/path/to/certfile',
        :username      => 'amqp_user',
        :password      => 'password'
      ) }
    end

    context 'with image_conversion_dir' do
      let :params do
        req_params.merge({
          :image_conversion_dir => '/tmp/foo',
        })
      end

      it { is_expected.to contain_cinder_config('DEFAULT/image_conversion_dir').with_value('/tmp/foo') }
    end

    context 'with host and enable_new_services' do
      let :params do
        req_params.merge({
          :host                => 'mystring',
          :enable_new_services => true,
        })
      end

      it { is_expected.to contain_cinder_config('DEFAULT/host').with_value('mystring') }
      it { is_expected.to contain_cinder_config('DEFAULT/enable_new_services').with_value(true) }
    end

    context 'with transport_url' do
      let :params do
        req_params.merge({
          :default_transport_url => 'rabbit://rabbit_user:password@localhost:5673',
        })
      end

      it { is_expected.to contain_oslo__messaging__default('cinder_config').with(
        :transport_url => 'rabbit://rabbit_user:password@localhost:5673'
      ) }
    end

    context 'with control_exchange' do
      let :params do
        req_params.merge({
          :control_exchange => 'cinder',
        })
      end

      it { is_expected.to contain_oslo__messaging__default('cinder_config').with(
        :control_exchange => 'cinder'
      ) }
    end

    context 'with notifications' do
      let :params do
        req_params.merge({
          :notification_transport_url => 'rabbit://notif_user:password@localhost:5673',
          :notification_driver        => 'messagingv2',
          :notification_topics        => 'test',
        })
      end

      it { is_expected.to contain_oslo__messaging__notifications('cinder_config').with(
        :transport_url => params[:notification_transport_url],
        :driver        => params[:notification_driver],
        :topics        => params[:notification_topics],
      )}
    end

    context 'with keymgr parameters' do
      let :params do
        req_params.merge!({
          :keymgr_backend             => 'barbican',
          :keymgr_encryption_api_url  => 'https://localhost:9311/v1',
          :keymgr_encryption_auth_url => 'https://localhost:5000/v3',
        })
      end
      it 'should set keymgr parameters' do
        is_expected.to contain_cinder_config('key_manager/backend').with_value('barbican')
        is_expected.to contain_cinder_config('barbican/barbican_endpoint').with_value('https://localhost:9311/v1')
        is_expected.to contain_cinder_config('barbican/auth_endpoint').with_value('https://localhost:5000/v3')
      end
    end

    context 'with volume api paramaters' do
      let :params do
        req_params.merge!({
          :enable_force_upload => true,
        })
      end
      it 'should set volume api parameters' do
        is_expected.to contain_cinder_config('DEFAULT/enable_force_upload').with_value(true)
      end
    end

    context 'with internal tenant parameters' do
      let :params do
        req_params.merge!({
          :cinder_internal_tenant_project_id => 'projectid',
          :cinder_internal_tenant_user_id    => 'userid',
        })
      end
      it 'should set internal tenant parameters' do
        is_expected.to contain_cinder_config('DEFAULT/cinder_internal_tenant_project_id').with_value('projectid')
        is_expected.to contain_cinder_config('DEFAULT/cinder_internal_tenant_user_id').with_value('userid')
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder'
    end
  end
end
