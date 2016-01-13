# == Class: cinder
#
#  Cinder base package & configuration
#
# === Parameters
#
# [*package_ensure*]
#    (Optional) Ensure state for package.
#    Defaults to 'present'
#
# [*verbose*]
#   (Optional) Should the daemons log verbose messages
#   Defaults to undef.
#
# [*debug*]
#   (Optional) Should the daemons log debug messages
#   Defaults to undef.
#
# [*rpc_backend*]
#   (Optional) Use these options to configure the RabbitMQ message system.
#   Defaults to 'rabbit'
#
# [*control_exchange*]
#   (Optional)
#   Defaults to 'openstack'.
#
# [*rabbit_host*]
#   (Optional) IP or hostname of the rabbit server.
#   Defaults to '127.0.0.1'
#
# [*rabbit_port*]
#   (Optional) Port of the rabbit server.
#   Defaults to 5672.
#
# [*rabbit_hosts*]
#   (Optional) Array of host:port (used with HA queues).
#   If defined, will remove rabbit_host & rabbit_port parameters from config
#   Defaults to undef.
#
# [*rabbit_userid*]
#   (Optional) User to connect to the rabbit server.
#   Defaults to 'guest'
#
# [*rabbit_password*]
#   (Required) Password to connect to the rabbit_server.
#   Defaults to empty. Required if using the Rabbit (kombu)
#   backend.
#
# [*rabbit_virtual_host*]
#   (Optional) Virtual_host to use.
#   Defaults to '/'
#
# [*rabbit_heartbeat_timeout_threshold*]
#   (optional) Number of seconds after which the RabbitMQ broker is considered
#   down if the heartbeat keepalive fails.  Any value >0 enables heartbeats.
#   Heartbeating helps to ensure the TCP connection to RabbitMQ isn't silently
#   closed, resulting in missed or lost messages from the queue.
#   (Requires kombu >= 3.0.7 and amqp >= 1.4.0)
#   Defaults to 0
#
# [*rabbit_heartbeat_rate*]
#   (optional) How often during the rabbit_heartbeat_timeout_threshold period to
#   check the heartbeat on RabbitMQ connection.  (i.e. rabbit_heartbeat_rate=2
#   when rabbit_heartbeat_timeout_threshold=60, the heartbeat will be checked
#   every 30 seconds.
#   Defaults to 2
#
# [*rabbit_use_ssl*]
#   (optional) Connect over SSL for RabbitMQ
#   Defaults to false
#
# [*report_interval*]
#  (optional) Interval, in seconds, between nodes reporting state to
#  datastore (integer value).
#  Defaults to $::os_service_default
#
# [*service_down_time*]
#  (optional) Maximum time since last check-in for a service to be
#  considered up (integer value).
#  Defaults to $::os_service_default
#
# [*kombu_ssl_ca_certs*]
#   (optional) SSL certification authority file (valid only if SSL enabled).
#   Defaults to $::os_service_default
#
# [*kombu_ssl_certfile*]
#   (optional) SSL cert file (valid only if SSL enabled).
#   Defaults to $::os_service_default
#
# [*kombu_ssl_keyfile*]
#   (optional) SSL key file (valid only if SSL enabled).
#   Defaults to $::os_service_default
#
# [*kombu_ssl_version*]
#   (optional) SSL version to use (valid only if SSL enabled).
#   Valid values are TLSv1, SSLv23 and SSLv3. SSLv2 may be
#   available on some distributions.
#   Defaults to $::os_service_default
#
# [*kombu_reconnect_delay*]
#   (optional) How long to wait before reconnecting in response to an AMQP
#   consumer cancel notification.
#   Defaults to $::os_service_default
#
# [*amqp_durable_queues*]
#   Use durable queues in amqp.
#   (Optional) Defaults to false.
#
# [*use_syslog*]
#   (Optional) Use syslog for logging.
#   Defaults to undef.
#
# [*database_connection*]
#    Url used to connect to database.
#    (Optional) Defaults to undef.
#
# [*database_idle_timeout*]
#   Timeout when db connections should be reaped.
#   (Optional) Defaults to undef.
#
# [*database_min_pool_size*]
#   Minimum number of SQL connections to keep open in a pool.
#   (Optional) Defaults to undef.
#
# [*database_max_pool_size*]
#   Maximum number of SQL connections to keep open in a pool.
#   (Optional) Defaults to undef.
#
# [*database_max_retries*]
#   Maximum db connection retries during startup.
#   Setting -1 implies an infinite retry count.
#   (Optional) Defaults to undef.
#
# [*database_retry_interval*]
#   Interval between retries of opening a sql connection.
#   (Optional) Defaults to underf.
#
# [*database_max_overflow*]
#   If set, use this value for max_overflow with sqlalchemy.
#   (Optional) Defaults to undef.
#
# [*use_stderr*]
#   (optional) Use stderr for logging
#   Defaults to undef.
#
# [*log_facility*]
#   (Optional) Syslog facility to receive log lines.
#   Defaults to undef.
#
# [*log_dir*]
#   (optional) Directory where logs should be stored.
#   If set to boolean false or the $::os_service_default, it will not log to
#   any directory.
#   Defaults to '/var/log/cinder'.
#
# [*use_ssl*]
#   (optional) Enable SSL on the API server
#   Defaults to false, not set
#
# [*cert_file*]
#   (optinal) Certificate file to use when starting API server securely
#   Defaults to false, not set
#
# [*key_file*]
#   (optional) Private key file to use when starting API server securely
#   Defaults to false, not set
#
# [*ca_file*]
#   (optional) CA certificate file to use to verify connecting clients
#   Defaults to $::os_service_default
#
# [*storage_availability_zone*]
#   (optional) Availability zone of the node.
#   Defaults to 'nova'
#
# [*default_availability_zone*]
#   (optional) Default availability zone for new volumes.
#   If not set, the storage_availability_zone option value is used as
#   the default for new volumes.
#   Defaults to false
#
# [*api_paste_config*]
#   (Optional)
#   Defaults to '/etc/cinder/api-paste.ini',
#
# [*enable_v1_api*]
#   (Optional) Whether to enable the v1 API (true/false).
#   This will be deprecated in Kilo.
#   Defaults to 'true'.
#
# [*enable_v2_api*]
#   (Optional) Whether to enable the v1 API (true/false).
#   Defaults to 'true'.
#
# [*lock_path*]
#   (optional) Where to store lock files. This directory must be writeable
#   by the user executing the agent
#   Defaults to: $::cinder::params::lock_path
#
# === Deprecated Parameters
#
# [*qpid_hostname*]
#   (Optional) Location of qpid server
#   Defaults to undef.
#
# [*qpid_port*]
#   (Optional) Port for qpid server.
#   Defaults to undef.
#
# [*qpid_hosts*]
#   (Optional) Qpid HA cluster host:port pairs. (list value)
#   Defaults to undef.
#
# [*qpid_username*]
#   (Optional) Username to use when connecting to qpid.
#   Defaults to undef.
#
# [*qpid_password*]
#   (Optional) Password to use when connecting to qpid.
#   Defaults to undef.
#
# [*qpid_sasl_mechanisms*]
#   (Optional) ENable one or more SASL mechanisms.
#   Defaults to undef.
#
# [*qpid_heartbeat*]
#   (Optional) Seconds between connection keepalive heartbeats.
#   Defaults to undef.
#
# [*qpid_protocol*]
#   (Optional) Transport to use, either 'tcp' or 'ssl'.
#   Defaults to undef.
#
# [*qpid_tcp_nodelay*]
#   (Optional) Disable Nagle Algorithm.
#   Defaults to undef.
#
# [*qpid_reconnect*]
#
# [*qpid_reconnect_timeout*]
#
# [*qpid_reconnect_limit*]
#
# [*qpid_reconnect_interval*]
#
# [*qpid_reconnect_interval_min*]
#
# [*qpid_reconnect_interval_max*]
#
class cinder (
  $database_connection                = undef,
  $database_idle_timeout              = undef,
  $database_min_pool_size             = undef,
  $database_max_pool_size             = undef,
  $database_max_retries               = undef,
  $database_retry_interval            = undef,
  $database_max_overflow              = undef,
  $rpc_backend                        = 'rabbit',
  $control_exchange                   = 'openstack',
  $rabbit_host                        = '127.0.0.1',
  $rabbit_port                        = 5672,
  $rabbit_hosts                       = false,
  $rabbit_virtual_host                = '/',
  $rabbit_heartbeat_timeout_threshold = 0,
  $rabbit_heartbeat_rate              = 2,
  $rabbit_userid                      = 'guest',
  $rabbit_password                    = false,
  $rabbit_use_ssl                     = false,
  $service_down_time                  = $::os_service_default,
  $report_interval                    = $::os_service_default,
  $kombu_ssl_ca_certs                 = $::os_service_default,
  $kombu_ssl_certfile                 = $::os_service_default,
  $kombu_ssl_keyfile                  = $::os_service_default,
  $kombu_ssl_version                  = $::os_service_default,
  $kombu_reconnect_delay              = $::os_service_default,
  $amqp_durable_queues                = false,
  $package_ensure                     = 'present',
  $use_ssl                            = false,
  $ca_file                            = $::os_service_default,
  $cert_file                          = false,
  $key_file                           = false,
  $api_paste_config                   = '/etc/cinder/api-paste.ini',
  $use_syslog                         = undef,
  $use_stderr                         = undef,
  $log_facility                       = undef,
  $log_dir                            = '/var/log/cinder',
  $verbose                            = undef,
  $debug                              = undef,
  $storage_availability_zone          = 'nova',
  $default_availability_zone          = false,
  $enable_v1_api                      = true,
  $enable_v2_api                      = true,
  $lock_path                          = $::cinder::params::lock_path,
  # DEPRECATED PARAMETERS
  $qpid_hostname                      = undef,
  $qpid_port                          = undef,
  $qpid_hosts                         = undef,
  $qpid_username                      = undef,
  $qpid_password                      = undef,
  $qpid_sasl_mechanisms               = undef,
  $qpid_reconnect                     = undef,
  $qpid_reconnect_timeout             = undef,
  $qpid_reconnect_limit               = undef,
  $qpid_reconnect_interval_min        = undef,
  $qpid_reconnect_interval_max        = undef,
  $qpid_reconnect_interval            = undef,
  $qpid_heartbeat                     = undef,
  $qpid_protocol                      = undef,
  $qpid_tcp_nodelay                   = undef,

) inherits cinder::params {

  include ::cinder::db
  include ::cinder::logging

  if $use_ssl {
    if !$cert_file {
      fail('The cert_file parameter is required when use_ssl is set to true')
    }
    if !$key_file {
      fail('The key_file parameter is required when use_ssl is set to true')
    }
  }

  # this anchor is used to simplify the graph between cinder components by
  # allowing a resource to serve as a point where the configuration of cinder begins
  anchor { 'cinder-start': }

  package { 'cinder':
    ensure  => $package_ensure,
    name    => $::cinder::params::package_name,
    tag     => ['openstack', 'cinder-package'],
    require => Anchor['cinder-start'],
  }

  if $rpc_backend == 'cinder.openstack.common.rpc.impl_kombu' or $rpc_backend == 'rabbit' {

    if ! $rabbit_password {
      fail('Please specify a rabbit_password parameter.')
    }

    cinder_config {
      'oslo_messaging_rabbit/rabbit_password':              value => $rabbit_password, secret => true;
      'oslo_messaging_rabbit/rabbit_userid':                value => $rabbit_userid;
      'oslo_messaging_rabbit/rabbit_virtual_host':          value => $rabbit_virtual_host;
      'oslo_messaging_rabbit/rabbit_use_ssl':               value => $rabbit_use_ssl;
      'oslo_messaging_rabbit/kombu_ssl_version':            value => $kombu_ssl_version;
      'oslo_messaging_rabbit/kombu_ssl_ca_certs':           value => $kombu_ssl_ca_certs;
      'oslo_messaging_rabbit/kombu_ssl_certfile':           value => $kombu_ssl_certfile;
      'oslo_messaging_rabbit/kombu_ssl_keyfile':            value => $kombu_ssl_keyfile;
      'oslo_messaging_rabbit/kombu_reconnect_delay':        value => $kombu_reconnect_delay;
      'oslo_messaging_rabbit/heartbeat_timeout_threshold':  value => $rabbit_heartbeat_timeout_threshold;
      'oslo_messaging_rabbit/heartbeat_rate':               value => $rabbit_heartbeat_rate;
      'DEFAULT/control_exchange':                           value => $control_exchange;
      'DEFAULT/report_interval':                            value => $report_interval;
      'DEFAULT/service_down_time':                          value => $service_down_time;
      'oslo_messaging_rabbit/amqp_durable_queues':          value => $amqp_durable_queues;
    }

    if $rabbit_hosts {
      cinder_config { 'oslo_messaging_rabbit/rabbit_hosts':     value => join($rabbit_hosts, ',') }
      cinder_config { 'oslo_messaging_rabbit/rabbit_ha_queues': value => true }
      cinder_config { 'oslo_messaging_rabbit/rabbit_host':      ensure => absent }
      cinder_config { 'oslo_messaging_rabbit/rabbit_port':      ensure => absent }
    } else {
      cinder_config { 'oslo_messaging_rabbit/rabbit_host':      value => $rabbit_host }
      cinder_config { 'oslo_messaging_rabbit/rabbit_port':      value => $rabbit_port }
      cinder_config { 'oslo_messaging_rabbit/rabbit_hosts':     value => "${rabbit_host}:${rabbit_port}" }
      cinder_config { 'oslo_messaging_rabbit/rabbit_ha_queues': value => false }
    }

  }

  if $rpc_backend == 'cinder.openstack.common.rpc.impl_qpid' or $rpc_backend == 'qpid' {
    warning('Qpid driver is removed from Oslo.messaging in the Mitaka release')
  }

  if ! $default_availability_zone {
    $default_availability_zone_real = $storage_availability_zone
  } else {
    $default_availability_zone_real = $default_availability_zone
  }

  cinder_config {
    'DEFAULT/api_paste_config':          value => $api_paste_config;
    'DEFAULT/rpc_backend':               value => $rpc_backend;
    'DEFAULT/storage_availability_zone': value => $storage_availability_zone;
    'DEFAULT/default_availability_zone': value => $default_availability_zone_real;
  }

  # SSL Options
  if $use_ssl {
    cinder_config {
      'DEFAULT/ssl_cert_file' : value => $cert_file;
      'DEFAULT/ssl_key_file' :  value => $key_file;
      'DEFAULT/ssl_ca_file' :   value => $ca_file;
    }
  } else {
    cinder_config {
      'DEFAULT/ssl_cert_file' : ensure => absent;
      'DEFAULT/ssl_key_file' :  ensure => absent;
      'DEFAULT/ssl_ca_file' :   ensure => absent;
    }
  }

  # V1/V2 APIs
  cinder_config {
    'DEFAULT/enable_v1_api':        value => $enable_v1_api;
    'DEFAULT/enable_v2_api':        value => $enable_v2_api;
    'oslo_concurrency/lock_path':   value => $lock_path;
  }

}
