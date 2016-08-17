require 'spec_helper'
describe 'cinder' do
  let :req_params do
    {
      :rabbit_password => 'guest',
      :database_connection => 'mysql://user:password@host/database',
      :lock_path => '/var/lock/cinder',
    }
  end

  let :facts do
    OSDefaults.get_facts({
      :osfamily => 'Debian',
      :operatingsystem => 'Debian',
      :operatingsystemrelease => 'jessie',
    })
  end

  describe 'with only required params' do
    let :params do
      req_params
    end

    it { is_expected.to contain_class('cinder::logging') }
    it { is_expected.to contain_class('cinder::params') }
    it { is_expected.to contain_class('mysql::bindings::python') }

    it 'passes purge to resource' do
      is_expected.to contain_resources('cinder_config').with({
        :purge => false
      })
    end

    it 'should contain default config' do
      is_expected.to contain_cinder_config('DEFAULT/transport_url').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('DEFAULT/rpc_backend').with(:value => 'rabbit')
      is_expected.to contain_cinder_config('DEFAULT/control_exchange').with(:value => 'openstack')
      is_expected.to contain_cinder_config('DEFAULT/report_interval').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('DEFAULT/service_down_time').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_password').with(:value => 'guest', :secret => true)
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_host').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_port').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_hosts').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_ha_queues').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_virtual_host').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/heartbeat_timeout_threshold').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/heartbeat_rate').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_userid').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/kombu_reconnect_delay').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/kombu_compression').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('DEFAULT/storage_availability_zone').with(:value => 'nova')
      is_expected.to contain_cinder_config('DEFAULT/default_availability_zone').with(:value => 'nova')
      is_expected.to contain_cinder_config('DEFAULT/allow_availability_zone_fallback').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('DEFAULT/api_paste_config').with(:value => '/etc/cinder/api-paste.ini')
      is_expected.to contain_cinder_config('oslo_concurrency/lock_path').with(:value => '/var/lock/cinder')
    end

  end
  describe 'with modified rabbit_hosts' do
    let :params do
      req_params.merge({'rabbit_hosts' => ['rabbit1:5672', 'rabbit2:5672']})
    end

    it 'should contain many' do
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_host').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_port').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_hosts').with(:value => 'rabbit1:5672,rabbit2:5672')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_ha_queues').with(:value => true)
    end
  end

  describe 'with a single rabbit_hosts entry' do
    let :params do
      req_params.merge({'rabbit_hosts' => ['rabbit1:5672']})
    end

    it 'should contain many' do
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_host').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_port').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_hosts').with(:value => 'rabbit1:5672')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_ha_queues').with(:value => '<SERVICE DEFAULT>')
    end
  end

  describe 'a single rabbit_host with enable ha queues' do
    let :params do
      req_params.merge({'rabbit_ha_queues' => true})
    end

    it 'should contain rabbit_ha_queues' do
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_ha_queues').with(:value => true)
    end
  end

  describe 'with rabbitmq heartbeats' do
    let :params do
      req_params.merge({'rabbit_heartbeat_timeout_threshold' => '60', 'rabbit_heartbeat_rate' => '10'})
    end

    it 'should contain heartbeat config' do
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/heartbeat_timeout_threshold').with_value('60')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/heartbeat_rate').with_value('10')
    end
  end

  describe 'with SSL enabled with kombu' do
    let :params do
      req_params.merge!({
        :rabbit_use_ssl     => true,
        :kombu_ssl_ca_certs => '/path/to/ssl/ca/certs',
        :kombu_ssl_certfile => '/path/to/ssl/cert/file',
        :kombu_ssl_keyfile  => '/path/to/ssl/keyfile',
        :kombu_ssl_version  => 'TLSv1'
      })
    end

    it do
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value('true')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/kombu_ssl_ca_certs').with_value('/path/to/ssl/ca/certs')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/kombu_ssl_certfile').with_value('/path/to/ssl/cert/file')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/kombu_ssl_keyfile').with_value('/path/to/ssl/keyfile')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/kombu_ssl_version').with_value('TLSv1')
    end
  end

  describe 'with SSL enabled without kombu' do
    let :params do
      req_params.merge!({
        :rabbit_use_ssl     => true,
      })
    end

    it do
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value('true')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/kombu_ssl_ca_certs').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/kombu_ssl_certfile').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/kombu_ssl_keyfile').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/kombu_ssl_version').with_value('<SERVICE DEFAULT>')
    end
  end

  describe 'with SSL disabled' do
    let :params do
      req_params.merge!({
        :rabbit_use_ssl     => false,
        :kombu_ssl_ca_certs => '<SERVICE DEFAULT>',
        :kombu_ssl_certfile => '<SERVICE DEFAULT>',
        :kombu_ssl_keyfile  => '<SERVICE DEFAULT>',
        :kombu_ssl_version  => '<SERVICE DEFAULT>'
      })
    end

    it do
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value('false')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/kombu_ssl_ca_certs').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/kombu_ssl_certfile').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/kombu_ssl_keyfile').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/kombu_ssl_version').with_value('<SERVICE DEFAULT>')
    end
  end

  describe 'with different lock_path' do
    let(:params) { req_params.merge!({:lock_path => '/var/run/cinder.locks'}) }
    it { is_expected.to contain_cinder_config('oslo_concurrency/lock_path').with_value('/var/run/cinder.locks') }
  end

  describe 'with amqp_durable_queues disabled' do
    let :params do
      req_params
    end

    it { is_expected.to contain_cinder_config('oslo_messaging_rabbit/amqp_durable_queues').with_value('<SERVICE DEFAULT>') }
  end

  describe 'with amqp_durable_queues enabled' do
    let :params do
      req_params.merge({
        :amqp_durable_queues => true,
      })
    end

    it { is_expected.to contain_cinder_config('oslo_messaging_rabbit/amqp_durable_queues').with_value(true) }
  end

  describe 'with amqp rpc_backend defaults' do
    let :params do
      { :rpc_backend => 'amqp' }
    end

    it 'configures amqp' do
      is_expected.to contain_cinder_config('DEFAULT/rpc_backend').with_value('amqp')
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
    end
  end

  describe 'with amqp rpc_backend overrides' do
    let :params do
    {
      :rpc_backend        => 'amqp',
      :amqp_idle_timeout  => '60',
      :amqp_trace         => true,
      :amqp_ssl_ca_file   => '/path/to/ca.cert',
      :amqp_ssl_cert_file => '/path/to/certfile',
      :amqp_ssl_key_file  => '/path/to/key',
      :amqp_username      => 'amqp_user',
      :amqp_password      => 'password',
    }
    end

    it do
      is_expected.to contain_cinder_config('DEFAULT/rpc_backend').with_value('amqp')
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
    end
  end

  describe 'with postgresql' do
    let :params do
      {
        :database_connection      => 'postgresql://user:drowssap@host/database',
        :rabbit_password       => 'guest',
      }
    end

    it { is_expected.to_not contain_class('mysql::python') }
    it { is_expected.to_not contain_class('mysql::bindings') }
    it { is_expected.to_not contain_class('mysql::bindings::python') }
  end

  describe 'with APIs set for Mitaka (proposed)' do
    let :params do
      {
        :enable_v3_api   => true,
        :rabbit_password => 'guest',
      }
    end

    it { is_expected.to contain_cinder_config('DEFAULT/enable_v3_api').with_value(true) }

  end

  describe 'with image_conversion_dir' do
    let :params do
      req_params.merge({
        :image_conversion_dir => '/tmp/foo',
      })
    end

    it { is_expected.to contain_cinder_config('DEFAULT/image_conversion_dir').with_value('/tmp/foo') }
  end

  describe 'with host' do
    let :params do
      req_params.merge({
        :host => 'mystring',
      })
    end

    it { is_expected.to contain_cinder_config('DEFAULT/host').with_value('mystring') }
  end

  describe 'with transport_url' do
    let :params do
      req_params.merge({
        :default_transport_url => 'rabbit://rabbit_user:password@localhost:5673',
      })
    end

    it { is_expected.to contain_cinder_config('DEFAULT/transport_url').with_value('rabbit://rabbit_user:password@localhost:5673') }
  end
end
