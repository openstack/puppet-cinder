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
#
# [*debug*]
#   (Optional) Should the daemons log debug messages
#   Defaults to undef.
#
# [*default_transport_url*]
#    (optional) A URL representing the messaging driver to use and its full
#    configuration. Transport URLs take the form:
#      transport://user:pass@host1:port[,hostN:portN]/virtual_host
#    Defaults to $::os_service_default
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
#   Defaults to $::os_service_default
#
# [*rabbit_port*]
#   (Optional) Port of the rabbit server.
#   Defaults to $::os_service_default
#
# [*rabbit_hosts*]
#   (Optional) Array of host:port (used with HA queues).
#   If defined, will remove rabbit_host & rabbit_port parameters from config
#   Defaults to $::os_service_default
#
# [*rabbit_userid*]
#   (Optional) User to connect to the rabbit server.
#   Defaults to $::os_service_default
#
# [*rabbit_password*]
#   (Required) Password to connect to the rabbit_server.
#   Defaults to empty. Required if using the Rabbit (kombu) backend.
#
# [*rabbit_virtual_host*]
#   (Optional) Virtual_host to use.
#   Defaults to $::os_service_default
#
# [*rabbit_ha_queues*]
#   (optional) Use HA queues in RabbitMQ (x-ha-policy: all).
#   Defaults to $::os_service_default
#
# [*rabbit_heartbeat_timeout_threshold*]
#   (optional) Number of seconds after which the RabbitMQ broker is considered
#   down if the heartbeat keepalive fails.  Any value >0 enables heartbeats.
#   Heartbeating helps to ensure the TCP connection to RabbitMQ isn't silently
#   closed, resulting in missed or lost messages from the queue.
#   (Requires kombu >= 3.0.7 and amqp >= 1.4.0)
#   Defaults to $::os_service_default
#
# [*rabbit_heartbeat_rate*]
#   (optional) How often during the rabbit_heartbeat_timeout_threshold period to
#   check the heartbeat on RabbitMQ connection.  (i.e. rabbit_heartbeat_rate=2
#   when rabbit_heartbeat_timeout_threshold=60, the heartbeat will be checked
#   every 30 seconds.
#   Defaults to $::os_service_default
#
# [*rabbit_use_ssl*]
#   (optional) Connect over SSL for RabbitMQ
#   Defaults to $::os_service_default
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
# [*kombu_compression*]
#   (optional) Possible values are: gzip, bz2. If not set compression will not
#   be used. This option may notbe available in future versions. EXPERIMENTAL.
#   (string value)
#   Defaults to $::os_service_default
#
# [*amqp_durable_queues*]
#   Use durable queues in amqp.
#   (Optional) Defaults to $::os_service_default
#
# [*amqp_server_request_prefix*]
#   (Optional) Address prefix used when sending to a specific server
#   Defaults to $::os_service_default.
#
# [*amqp_broadcast_prefix*]
#   (Optional) address prefix used when broadcasting to all servers
#   Defaults to $::os_service_default.
#
# [*amqp_group_request_prefix*]
#   (Optional) address prefix when sending to any server in group
#   Defaults to $::os_service_default.
#
# [*amqp_container_name*]
#   (Optional) Name for the AMQP container
#   Defaults to $::os_service_default.
#
# [*amqp_idle_timeout*]
#   (Optional) Timeout for inactive connections
#   Defaults to $::os_service_default.
#
# [*amqp_trace*]
#   (Optional) Debug: dump AMQP frames to stdout
#   Defaults to $::os_service_default.
#
# [*amqp_ssl_ca_file*]
#   (Optional) CA certificate PEM file to verify server certificate
#   Defaults to $::os_service_default.
#
# [*amqp_ssl_cert_file*]
#   (Optional) Identifying certificate PEM file to present to clients
#   Defaults to $::os_service_default.
#
# [*amqp_ssl_key_file*]
#   (Optional) Private key PEM file used to sign cert_file certificate
#   Defaults to $::os_service_default.
#
# [*amqp_ssl_key_password*]
#   (Optional) Password for decrypting ssl_key_file (if encrypted)
#   Defaults to $::os_service_default.
#
# [*amqp_allow_insecure_clients*]
#   (Optional) Accept clients using either SSL or plain TCP
#   Defaults to $::os_service_default.
#
# [*amqp_sasl_mechanisms*]
#   (Optional) Space separated list of acceptable SASL mechanisms
#   Defaults to $::os_service_default.
#
# [*amqp_sasl_config_dir*]
#   (Optional) Path to directory that contains the SASL configuration
#   Defaults to $::os_service_default.
#
# [*amqp_sasl_config_name*]
#   (Optional) Name of configuration file (without .conf suffix)
#   Defaults to $::os_service_default.
#
# [*amqp_username*]
#   (Optional) User name for message broker authentication
#   Defaults to $::os_service_default.
#
# [*amqp_password*]
#   (Optional) Password for message broker authentication
#   Defaults to $::os_service_default.
#
# [*use_syslog*]
#   (Optional) Use syslog for logging.
#   Defaults to undef
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
#   (Optional) Defaults to undef.
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
# [*allow_availability_zone_fallback*]
#   (optional) Allow availability zone fallback if preferred availabilty zone cannot be deployed to.
#   Defaults to $::os_service_default
#
# [*api_paste_config*]
#   (Optional)
#   Defaults to '/etc/cinder/api-paste.ini',
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
# [*purge_config*]
#   (optional) Whether to set only the specified config options
#   in the cinder config.
#   Defaults to false.
#
# DEPRECATED PARAMETERS
#
# [*verbose*]
#   (Optional) DEPRECATED. Should the daemons log verbose messages
#   Defaults to undef.
#
# [*enable_v1_api*]
#   (Optional) DEPRECATED. Whether to enable the v1 API (true/false).
#   Defaults to undef.
#
# [*enable_v2_api*]
#   (Optional) DEPRECATED. Whether to enable the v2 API (true/false).
#   Defaults to undef.
#
# [*use_ssl*]
#   (optional) DEPRECATED. Enable SSL on the API server
#   Defaults to undef
#
# [*cert_file*]
#   (optional) DEPRECATED. Certificate file to use when starting API server
#   securely
#   Defaults to undef
#
# [*key_file*]
#   (optional) DEPRECATED. Private key file to use when starting API server
#   securely
#   Defaults to undef
#
# [*ca_file*]
#   (optional) DEPRECATED. CA certificate file to use to verify connecting
#   clients
#   Defaults to undef
#
class cinder (
  $database_connection                = undef,
  $database_idle_timeout              = undef,
  $database_min_pool_size             = undef,
  $database_max_pool_size             = undef,
  $database_max_retries               = undef,
  $database_retry_interval            = undef,
  $database_max_overflow              = undef,
  $default_transport_url              = $::os_service_default,
  $rpc_backend                        = 'rabbit',
  $control_exchange                   = 'openstack',
  $rabbit_host                        = $::os_service_default,
  $rabbit_port                        = $::os_service_default,
  $rabbit_hosts                       = $::os_service_default,
  $rabbit_virtual_host                = $::os_service_default,
  $rabbit_ha_queues                   = $::os_service_default,
  $rabbit_heartbeat_timeout_threshold = $::os_service_default,
  $rabbit_heartbeat_rate              = $::os_service_default,
  $rabbit_userid                      = $::os_service_default,
  $rabbit_password                    = $::os_service_default,
  $rabbit_use_ssl                     = $::os_service_default,
  $service_down_time                  = $::os_service_default,
  $report_interval                    = $::os_service_default,
  $kombu_ssl_ca_certs                 = $::os_service_default,
  $kombu_ssl_certfile                 = $::os_service_default,
  $kombu_ssl_keyfile                  = $::os_service_default,
  $kombu_ssl_version                  = $::os_service_default,
  $kombu_reconnect_delay              = $::os_service_default,
  $kombu_compression                  = $::os_service_default,
  $amqp_durable_queues                = $::os_service_default,
  $amqp_server_request_prefix         = $::os_service_default,
  $amqp_broadcast_prefix              = $::os_service_default,
  $amqp_group_request_prefix          = $::os_service_default,
  $amqp_container_name                = $::os_service_default,
  $amqp_idle_timeout                  = $::os_service_default,
  $amqp_trace                         = $::os_service_default,
  $amqp_ssl_ca_file                   = $::os_service_default,
  $amqp_ssl_cert_file                 = $::os_service_default,
  $amqp_ssl_key_file                  = $::os_service_default,
  $amqp_ssl_key_password              = $::os_service_default,
  $amqp_allow_insecure_clients        = $::os_service_default,
  $amqp_sasl_mechanisms               = $::os_service_default,
  $amqp_sasl_config_dir               = $::os_service_default,
  $amqp_sasl_config_name              = $::os_service_default,
  $amqp_username                      = $::os_service_default,
  $amqp_password                      = $::os_service_default,
  $package_ensure                     = 'present',
  $api_paste_config                   = '/etc/cinder/api-paste.ini',
  $use_syslog                         = undef,
  $use_stderr                         = undef,
  $log_facility                       = undef,
  $log_dir                            = '/var/log/cinder',
  $debug                              = undef,
  $storage_availability_zone          = 'nova',
  $default_availability_zone          = false,
  $allow_availability_zone_fallback   = $::os_service_default,
  $enable_v3_api                      = true,
  $lock_path                          = $::cinder::params::lock_path,
  $image_conversion_dir               = $::os_service_default,
  $host                               = $::os_service_default,
  $purge_config                       = false,
  # DEPRECATED PARAMETERS
  $verbose                            = undef,
  $enable_v1_api                      = undef,
  $enable_v2_api                      = undef,
  $use_ssl                            = undef,
  $ca_file                            = undef,
  $cert_file                          = undef,
  $key_file                           = undef,
) inherits cinder::params {

  include ::cinder::deps
  include ::cinder::db
  include ::cinder::logging

  if $verbose {
    warning('verbose is deprecated, has no effect and will be removed after Newton cycle.')
  }

  if $enable_v1_api {
    warning('enable_v1_api is deprecated, has no effect and will be removed in a future release')
  }

  if $enable_v2_api {
    warning('enable_v2_api is deprecated, has no effect and will be removed in a future release')
  }

  package { 'cinder':
    ensure => $package_ensure,
    name   => $::cinder::params::package_name,
    tag    => ['openstack', 'cinder-package'],
  }

  resources { 'cinder_config':
    purge => $purge_config,
  }

  if $rpc_backend == 'cinder.openstack.common.rpc.impl_kombu' or $rpc_backend == 'rabbit' {

    if is_service_default($default_transport_url) and is_service_default($rabbit_password) {
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
      kombu_compression           => $kombu_compression,
    }
  }
  elsif $rpc_backend == 'amqp' {

    oslo::messaging::amqp { 'cinder_config':
      server_request_prefix  => $amqp_server_request_prefix,
      broadcast_prefix       => $amqp_broadcast_prefix,
      group_request_prefix   => $amqp_group_request_prefix,
      container_name         => $amqp_container_name,
      idle_timeout           => $amqp_idle_timeout,
      trace                  => $amqp_trace,
      ssl_ca_file            => $amqp_ssl_ca_file,
      ssl_cert_file          => $amqp_ssl_cert_file,
      ssl_key_file           => $amqp_ssl_key_file,
      ssl_key_password       => $amqp_ssl_key_password,
      allow_insecure_clients => $amqp_allow_insecure_clients,
      sasl_mechanisms        => $amqp_sasl_mechanisms,
      sasl_config_dir        => $amqp_sasl_config_dir,
      sasl_config_name       => $amqp_sasl_config_name,
      username               => $amqp_username,
      password               => $amqp_password,
    }
  }

  oslo::messaging::default { 'cinder_config':
    transport_url    => $default_transport_url,
    control_exchange => $control_exchange,
  }

  if ! $default_availability_zone {
    $default_availability_zone_real = $storage_availability_zone
  } else {
    $default_availability_zone_real = $default_availability_zone
  }

  cinder_config {
    'DEFAULT/report_interval':                  value => $report_interval;
    'DEFAULT/service_down_time':                value => $service_down_time;
    'DEFAULT/api_paste_config':                 value => $api_paste_config;
    'DEFAULT/storage_availability_zone':        value => $storage_availability_zone;
    'DEFAULT/default_availability_zone':        value => $default_availability_zone_real;
    'DEFAULT/allow_availability_zone_fallback': value => $allow_availability_zone_fallback;
    'DEFAULT/image_conversion_dir':             value => $image_conversion_dir;
    'DEFAULT/host':                             value => $host;
  }

  # V3 APIs
  cinder_config {
    'DEFAULT/enable_v3_api':        value => $enable_v3_api;
  }

  oslo::concurrency { 'cinder_config':
    lock_path => $lock_path
  }
}
