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
    @default_facts.merge({
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

    it 'should contain default config' do
      is_expected.to contain_cinder_config('DEFAULT/rpc_backend').with(:value => 'rabbit')
      is_expected.to contain_cinder_config('DEFAULT/control_exchange').with(:value => 'openstack')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_password').with(:value => 'guest', :secret => true)
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_host').with(:value => '127.0.0.1')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_port').with(:value => '5672')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_hosts').with(:value => '127.0.0.1:5672')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_ha_queues').with(:value => false)
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_virtual_host').with(:value => '/')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/heartbeat_timeout_threshold').with_value('0')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/heartbeat_rate').with_value('2')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_userid').with(:value => 'guest')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/kombu_reconnect_delay').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('DEFAULT/storage_availability_zone').with(:value => 'nova')
      is_expected.to contain_cinder_config('DEFAULT/default_availability_zone').with(:value => 'nova')
      is_expected.to contain_cinder_config('DEFAULT/api_paste_config').with(:value => '/etc/cinder/api-paste.ini')
      is_expected.to contain_cinder_config('DEFAULT/lock_path').with(:value => '/var/lock/cinder')
    end

  end
  describe 'with modified rabbit_hosts' do
    let :params do
      req_params.merge({'rabbit_hosts' => ['rabbit1:5672', 'rabbit2:5672']})
    end

    it 'should contain many' do
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_host').with(:value => nil)
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_port').with(:value => nil)
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_hosts').with(:value => 'rabbit1:5672,rabbit2:5672')
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_ha_queues').with(:value => true)
    end
  end

  describe 'with a single rabbit_hosts entry' do
    let :params do
      req_params.merge({'rabbit_hosts' => ['rabbit1:5672']})
    end

    it 'should contain many' do
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_host').with(:value => nil)
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_port').with(:value => nil)
      is_expected.to contain_cinder_config('oslo_messaging_rabbit/rabbit_hosts').with(:value => 'rabbit1:5672')
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
    it { is_expected.to contain_cinder_config('DEFAULT/lock_path').with_value('/var/run/cinder.locks') }
  end

  describe 'with amqp_durable_queues disabled' do
    let :params do
      req_params
    end

    it { is_expected.to contain_cinder_config('oslo_messaging_rabbit/amqp_durable_queues').with_value(false) }
  end

  describe 'with amqp_durable_queues enabled' do
    let :params do
      req_params.merge({
        :amqp_durable_queues => true,
      })
    end

    it { is_expected.to contain_cinder_config('oslo_messaging_rabbit/amqp_durable_queues').with_value(true) }
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

  describe 'with SSL socket options set' do
    let :params do
      {
        :use_ssl         => true,
        :cert_file       => '/path/to/cert',
        :ca_file         => '/path/to/ca',
        :key_file        => '/path/to/key',
        :rabbit_password => 'guest',
      }
    end

    it { is_expected.to contain_cinder_config('DEFAULT/ssl_ca_file').with_value('/path/to/ca') }
    it { is_expected.to contain_cinder_config('DEFAULT/ssl_cert_file').with_value('/path/to/cert') }
    it { is_expected.to contain_cinder_config('DEFAULT/ssl_key_file').with_value('/path/to/key') }
  end

  describe 'with SSL socket options set to false' do
    let :params do
      {
        :use_ssl         => false,
        :cert_file       => false,
        :ca_file         => false,
        :key_file        => false,
        :rabbit_password => 'guest',
      }
    end

    it { is_expected.to contain_cinder_config('DEFAULT/ssl_ca_file').with_ensure('absent') }
    it { is_expected.to contain_cinder_config('DEFAULT/ssl_cert_file').with_ensure('absent') }
    it { is_expected.to contain_cinder_config('DEFAULT/ssl_key_file').with_ensure('absent') }
  end

  describe 'with SSL socket options set wrongly configured' do
    let :params do
      {
        :use_ssl         => true,
        :ca_file         => '/path/to/ca',
        :key_file        => '/path/to/key',
        :rabbit_password => 'guest',
      }
    end

    it_raises 'a Puppet::Error', /The cert_file parameter is required when use_ssl is set to true/
  end

  describe 'with APIs set for Kilo (proposed)' do
    let :params do
      {
        :enable_v1_api   => false,
        :enable_v2_api   => true,
        :rabbit_password => 'guest',
      }
    end

    it { is_expected.to contain_cinder_config('DEFAULT/enable_v1_api').with_value(false) }
    it { is_expected.to contain_cinder_config('DEFAULT/enable_v2_api').with_value(true) }

  end
end
