require 'spec_helper'

describe 'cinder' do
  let :req_params do
    {
      :database_connection => 'mysql+pymysql://user:password@host/database',
      :lock_path           => '/var/lock/cinder',
    }
  end

  shared_examples 'cinder' do
    context 'with only required params' do
      let :params do
        req_params
      end

      it { is_expected.to contain_class('cinder::params') }
      it { is_expected.to contain_class('mysql::bindings::python') }

      it { is_expected.to contain_resources('cinder_config').with_purge(false) }

      it {
        is_expected.to contain_cinder_config('DEFAULT/transport_url').with(:value => '<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/rpc_response_timeout').with(:value => '<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/control_exchange').with(:value => 'openstack')
      }

      it { is_expected.to contain_oslo__messaging__notifications('cinder_config').with(
        :transport_url => '<SERVICE DEFAULT>',
        :driver        => '<SERVICE DEFAULT>',
        :topics        => '<SERVICE DEFAULT>',
      )}

      it {
        is_expected.to contain_cinder_config('DEFAULT/report_interval').with(:value => '<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/service_down_time').with(:value => '<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_ha_queues').with(:value => '<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_rabbit/heartbeat_timeout_threshold').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_rabbit/heartbeat_rate').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_rabbit/heartbeat_in_pthread').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_rabbit/kombu_reconnect_delay').with(:value => '<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_rabbit/kombu_failover_strategy').with(:value => '<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_rabbit/kombu_compression').with(:value => '<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/storage_availability_zone').with(:value => 'nova')
        is_expected.to contain_cinder_config('DEFAULT/default_availability_zone').with(:value => 'nova')
        is_expected.to contain_cinder_config('DEFAULT/allow_availability_zone_fallback').with(:value => '<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/api_paste_config').with(:value => '/etc/cinder/api-paste.ini')
        is_expected.to contain_cinder_config('DEFAULT/host').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/enable_new_services').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_concurrency/lock_path').with(:value => '/var/lock/cinder')

        # backend_host should not be written to DEFAULT section
        is_expected.not_to contain_cinder_config('DEFAULT/backend_host')
      }
    end

    context 'with enable ha queues' do
      let :params do
        req_params.merge( :rabbit_ha_queues => true )
      end

      it { is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value(true) }
    end

    context 'with rabbitmq heartbeats' do
      let :params do
        req_params.merge( :rabbit_heartbeat_timeout_threshold => '60',
                          :rabbit_heartbeat_rate              => '10',
                          :rabbit_heartbeat_in_pthread        => true )
      end

      it { is_expected.to contain_cinder_config('oslo_messaging_rabbit/heartbeat_timeout_threshold').with_value('60') }
      it { is_expected.to contain_cinder_config('oslo_messaging_rabbit/heartbeat_rate').with_value('10') }
      it { is_expected.to contain_cinder_config('oslo_messaging_rabbit/heartbeat_in_pthread').with_value(true) }
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

      it { is_expected.to contain_cinder_config('oslo_concurrency/lock_path').with_value('/var/run/cinder.locks') }
    end

    context 'with amqp_durable_queues disabled' do
      let :params do
        req_params
      end

      it { is_expected.to contain_cinder_config('oslo_messaging_rabbit/amqp_durable_queues').with_value('<SERVICE DEFAULT>') }
    end

    context 'with amqp_durable_queues enabled' do
      let :params do
        req_params.merge({
          :amqp_durable_queues => true,
        })
      end

      it { is_expected.to contain_cinder_config('oslo_messaging_rabbit/amqp_durable_queues').with_value(true) }
    end

    context 'with amqp defaults' do
      it {
        is_expected.to contain_cinder_config('oslo_messaging_amqp/server_request_prefix').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_amqp/broadcast_prefix').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_amqp/group_request_prefix').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_amqp/container_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_amqp/idle_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_amqp/trace').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_amqp/ssl_ca_file').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_amqp/ssl_cert_file').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_amqp/ssl_key_file').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_amqp/ssl_key_password').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_amqp/allow_insecure_clients').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_amqp/sasl_mechanisms').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_amqp/sasl_config_dir').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_amqp/sasl_config_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_amqp/username').with_value('<SERVICE DEFAULT>')
       is_expected.to contain_cinder_config('oslo_messaging_amqp/password').with_value('<SERVICE DEFAULT>')
      }
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

      it {
        is_expected.to contain_cinder_config('oslo_messaging_amqp/server_request_prefix').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_amqp/broadcast_prefix').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_amqp/group_request_prefix').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_amqp/container_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_amqp/idle_timeout').with_value('60')
        is_expected.to contain_cinder_config('oslo_messaging_amqp/trace').with_value('true')
        is_expected.to contain_cinder_config('oslo_messaging_amqp/ssl_ca_file').with_value('/path/to/ca.cert')
        is_expected.to contain_cinder_config('oslo_messaging_amqp/ssl_cert_file').with_value('/path/to/certfile')
        is_expected.to contain_cinder_config('oslo_messaging_amqp/ssl_key_file').with_value('/path/to/key')
        is_expected.to contain_cinder_config('oslo_messaging_amqp/allow_insecure_clients').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_amqp/sasl_mechanisms').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_amqp/sasl_config_dir').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_amqp/sasl_config_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('oslo_messaging_amqp/username').with_value('amqp_user')
        is_expected.to contain_cinder_config('oslo_messaging_amqp/password').with_value('password')
      }
    end

    context 'with postgresql' do
      let :params do
        {
          :database_connection => 'postgresql://user:drowssap@host/database',
        }
      end

      it { is_expected.not_to contain_class('mysql::python') }
      it { is_expected.not_to contain_class('mysql::bindings') }
      it { is_expected.not_to contain_class('mysql::bindings::python') }
    end

    context 'with APIs set for Mitaka (proposed)' do
      let :params do
        {
          :enable_v3_api => true,
        }
      end

      it { is_expected.to contain_cinder_config('DEFAULT/enable_v3_api').with_value(true) }
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

      it { is_expected.to contain_cinder_config('DEFAULT/transport_url').with_value('rabbit://rabbit_user:password@localhost:5673') }
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
