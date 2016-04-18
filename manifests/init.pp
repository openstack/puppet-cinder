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
# [*rabbit_ha_queues*]
#   (optional) Use HA queues in RabbitMQ (x-ha-policy: all).
#   Defaults to undef
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
#   (Optional) Whether to enable the v2 API (true/false).
#   Defaults to 'true'.
#
# [*enable_v3_api*]
#   (Optional) Whether to enable the v3 API (true/false).
#   Defaults to 'true'.
#
# [*lock_path*]
#   (optional) Where to store lock files. This directory must be writeable
#   by the user executing the agent
#   Defaults to: $::cinder::params::lock_path
#
# [*image_conversion_dir*]
#   (optional) Location to store temporary image files if the volume
#   driver does not write them directly to the volume and the volume conversion
#   needs to be performed. This parameter replaces the
#   'cinder::backend::rdb::volume_tmp_dir' parameter.
#   Defaults to $::os_service_default
#
# [*host*]
#   (optional) Name of this node. This can be an opaque identifier. It is
#   not necessarily a host name, FQDN, or IP address.
#   Defaults to $::os_service_default
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
  $rabbit_hosts                       = undef,
  $rabbit_virtual_host                = '/',
  $rabbit_ha_queues                   = undef,
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
  $enable_v3_api                      = true,
  $lock_path                          = $::cinder::params::lock_path,
  $image_conversion_dir               = $::os_service_default,
  $host                               = $::os_service_default,

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

    oslo::messaging::rabbit { 'cinder_config':
      rabbit_userid               => $rabbit_userid,
      rabbit_password             => $rabbit_password,
      rabbit_virtual_host         => $rabbit_virtual_host,
      rabbit_host                 => $rabbit_host,
      rabbit_port                 => $rabbit_port,
      rabbit_hosts                => $rabbit_hosts,
      rabbit_ha_queues            => $rabbit_ha_queues,
      heartbeat_timeout_threshold => $rabbit_heartbeat_timeout_threshold,
      heartbeat_rate              => $rabbit_heartbeat_rate,
      rabbit_use_ssl              => $rabbit_use_ssl,
      kombu_reconnect_delay       => $kombu_reconnect_delay,
      kombu_ssl_version           => $kombu_ssl_version,
      kombu_ssl_keyfile           => $kombu_ssl_keyfile,
      kombu_ssl_certfile          => $kombu_ssl_certfile,
      kombu_ssl_ca_certs          => $kombu_ssl_ca_certs,
      amqp_durable_queues         => $amqp_durable_queues,
    }

    oslo::messaging::default { 'cinder_config':
      control_exchange => $control_exchange
    }

    cinder_config {
      'DEFAULT/report_interval':   value => $report_interval;
      'DEFAULT/service_down_time': value => $service_down_time;
    }
  }

  if ! $default_availability_zone {
    $default_availability_zone_real = $storage_availability_zone
  } else {
    $default_availability_zone_real = $default_availability_zone
  }

  cinder_config {
    'DEFAULT/api_paste_config':          value => $api_paste_config;
    'DEFAULT/storage_availability_zone': value => $storage_availability_zone;
    'DEFAULT/default_availability_zone': value => $default_availability_zone_real;
    'DEFAULT/image_conversion_dir':      value => $image_conversion_dir;
    'DEFAULT/host':                      value => $host;
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

  # V1/V2/V3 APIs
  cinder_config {
    'DEFAULT/enable_v1_api':        value => $enable_v1_api;
    'DEFAULT/enable_v2_api':        value => $enable_v2_api;
    'DEFAULT/enable_v3_api':        value => $enable_v3_api;
  }

  oslo::concurrency { 'cinder_config':
    lock_path => $lock_path
  }
}
