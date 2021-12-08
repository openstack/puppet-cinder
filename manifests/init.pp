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
# [*default_transport_url*]
#    (optional) A URL representing the messaging driver to use and its full
#    configuration. Transport URLs take the form:
#      transport://user:pass@host1:port[,hostN:portN]/virtual_host
#    Defaults to $::os_service_default
#
# [*rpc_response_timeout*]
#   (optional) Seconds to wait for a response from a call
#   Defaults to $::os_service_default
#
# [*control_exchange*]
#   (Optional)
#   Defaults to $::os_service_default
#
# [*notification_transport_url*]
#   (Optional) A URL representing the messaging driver to use for notifications
#   and its full configuration. Transport URLs take the form:
#     transport://user:pass@host1:port[,hostN:portN]/virtual_host
#   Defaults to $::os_service_default
#
# [*notification_driver*]
#   (Option) Driver or drivers to handle sending notifications.
#   Defaults to $::os_service_default
#
# [*notification_topics*]
#   (Optional) AMQP topic used for OpenStack notifications
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
# [*rabbit_heartbeat_in_pthread*]
#   (Optional) EXPERIMENTAL: Run the health check heartbeat thread
#   through a native python thread. By default if this
#   option isn't provided the  health check heartbeat will
#   inherit the execution model from the parent process. By
#   example if the parent process have monkey patched the
#   stdlib by using eventlet/greenlet then the heartbeat
#   will be run through a green thread.
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
# [*kombu_failover_strategy*]
#   (Optional) Determines how the next RabbitMQ node is chosen in case the one
#   we are currently connected to becomes unavailable. Takes effect only if
#   more than one RabbitMQ node is provided in config. (string value)
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
#   Defaults to $::os_service_default.
#
# [*enable_new_services*]
#   (optional) Services to be added to the available pool on create.
#   Defaults to $::os_service_default
#
# [*purge_config*]
#   (optional) Whether to set only the specified config options
#   in the cinder config.
#   Defaults to false.
#
# [*enable_force_upload*]
#   (optional) Enables the Force option on upload_to_image. This
#   enables running upload_volume on in-use volumes for backends that
#   support it.
#   Defaults to $::os_service_default.
#
# [*cinder_internal_tenant_project_id*]
#   (optional) ID of the project which will be used as the Cinder internal
#   tenant.
#   Defaults to $::os_service_default.
#
# [*cinder_internal_tenant_user_id*]
#   (optional) ID of the user to be used in volume operations as the Cinder
#   internal tenant.
#   Defaults to $::os_service_default.
#
# DEPRECATED PARAMETERS
#
# [*database_min_pool_size*]
#   Minimum number of SQL connections to keep open in a pool.
#   (Optional) Defaults to undef.
#
# [*database_connection*]
#    Url used to connect to database.
#    (Optional) Defaults to undef.
#
# [*database_idle_timeout*]
#   Timeout when db connections should be reaped.
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
# [*amqp_allow_insecure_clients*]
#   (Optional) Accept clients using either SSL or plain TCP
#   Defaults to undef.
#
# [*backend_host*]
#   (optional) Backend override of host value.
#   Defaults to undef.
#
# [*keymgr_backend*]
#   (Optional) Key Manager service class.
#   Example of valid value: barbican
#   Defaults to undef.
#
# [*keymgr_encryption_api_url*]
#   (Optional) Key Manager service URL
#   Example of valid value: https://localhost:9311/v1
#   Defaults to undef.
#
# [*keymgr_encryption_auth_url*]
#   (Optional) Auth URL for keymgr authentication. Should be in format
#   http://auth_url:5000/v3
#   Defaults to undef.
#
# [*enable_v3_api*]
#   (Optional) Whether to enable the v3 API (true/false).
#   Defaults to undef.
#
class cinder (
  $default_transport_url              = $::os_service_default,
  $rpc_response_timeout               = $::os_service_default,
  $control_exchange                   = $::os_service_default,
  $notification_transport_url         = $::os_service_default,
  $notification_driver                = $::os_service_default,
  $notification_topics                = $::os_service_default,
  $rabbit_ha_queues                   = $::os_service_default,
  $rabbit_heartbeat_timeout_threshold = $::os_service_default,
  $rabbit_heartbeat_rate              = $::os_service_default,
  $rabbit_heartbeat_in_pthread        = $::os_service_default,
  $rabbit_use_ssl                     = $::os_service_default,
  $service_down_time                  = $::os_service_default,
  $report_interval                    = $::os_service_default,
  $kombu_ssl_ca_certs                 = $::os_service_default,
  $kombu_ssl_certfile                 = $::os_service_default,
  $kombu_ssl_keyfile                  = $::os_service_default,
  $kombu_ssl_version                  = $::os_service_default,
  $kombu_reconnect_delay              = $::os_service_default,
  $kombu_failover_strategy            = $::os_service_default,
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
  $amqp_sasl_mechanisms               = $::os_service_default,
  $amqp_sasl_config_dir               = $::os_service_default,
  $amqp_sasl_config_name              = $::os_service_default,
  $amqp_username                      = $::os_service_default,
  $amqp_password                      = $::os_service_default,
  $package_ensure                     = 'present',
  $api_paste_config                   = '/etc/cinder/api-paste.ini',
  $storage_availability_zone          = 'nova',
  $default_availability_zone          = false,
  $allow_availability_zone_fallback   = $::os_service_default,
  $lock_path                          = $::cinder::params::lock_path,
  $image_conversion_dir               = $::os_service_default,
  $host                               = $::os_service_default,
  $enable_new_services                = $::os_service_default,
  $purge_config                       = false,
  $enable_force_upload                = $::os_service_default,
  $cinder_internal_tenant_project_id  = $::os_service_default,
  $cinder_internal_tenant_user_id     = $::os_service_default,
  # DEPRECATED PARAMETERS
  $database_min_pool_size             = undef,
  $database_connection                = undef,
  $database_idle_timeout              = undef,
  $database_max_pool_size             = undef,
  $database_max_retries               = undef,
  $database_retry_interval            = undef,
  $database_max_overflow              = undef,
  $amqp_allow_insecure_clients        = undef,
  $backend_host                       = undef,
  $keymgr_backend                     = undef,
  $keymgr_encryption_api_url          = undef,
  $keymgr_encryption_auth_url         = undef,
  $enable_v3_api                      = undef,
) inherits cinder::params {

  include cinder::deps
  include cinder::db

  if $amqp_allow_insecure_clients != undef {
    warning('The amqp_allow_insecure_clients parameter is deprecated and \
will be removed in a future release.')
  }

  if $database_connection != undef {
    warning('The database_connection parameter is deprecated and will be \
removed in a future realse. Use cinder::db::database_connection instead')
  }

  if $database_idle_timeout != undef {
    warning('The database_idle_timeout parameter is deprecated and will be \
removed in a future realse. Use cinder::db::database_connection_recycle_time \
instead')
  }

  if $database_max_pool_size != undef {
    warning('The database_max_pool_size parameter is deprecated and will be \
removed in a future realse. Use cinder::db::database_max_pool_size instead')
  }

  if $database_max_retries!= undef {
    warning('The database_max_retries parameter is deprecated and will be \
removed in a future realse. Use cinder::db::database_max_retries instead')
  }

  if $database_retry_interval != undef {
    warning('The database_retry_interval parameter is deprecated and will be \
removed in a future realse. Use cinder::db::database_retry_interval instead')
  }

  if $database_max_overflow != undef {
    warning('The database_max_overflow parameter is deprecated and will be \
removed in a future realse. Use cinder::db::database_max_overflow instead')
  }

  if $enable_v3_api != undef {
    warning('The enable_v3_api parameter is deprecated and has no effect')
  }

  package { 'cinder':
    ensure => $package_ensure,
    name   => $::cinder::params::package_name,
    tag    => ['openstack', 'cinder-package'],
  }

  resources { 'cinder_config':
    purge => $purge_config,
  }

  oslo::messaging::rabbit { 'cinder_config':
    rabbit_ha_queues            => $rabbit_ha_queues,
    heartbeat_timeout_threshold => $rabbit_heartbeat_timeout_threshold,
    heartbeat_rate              => $rabbit_heartbeat_rate,
    heartbeat_in_pthread        => $rabbit_heartbeat_in_pthread,
    rabbit_use_ssl              => $rabbit_use_ssl,
    kombu_reconnect_delay       => $kombu_reconnect_delay,
    kombu_failover_strategy     => $kombu_failover_strategy,
    kombu_ssl_version           => $kombu_ssl_version,
    kombu_ssl_keyfile           => $kombu_ssl_keyfile,
    kombu_ssl_certfile          => $kombu_ssl_certfile,
    kombu_ssl_ca_certs          => $kombu_ssl_ca_certs,
    amqp_durable_queues         => $amqp_durable_queues,
    kombu_compression           => $kombu_compression,
  }

  oslo::messaging::amqp { 'cinder_config':
    server_request_prefix => $amqp_server_request_prefix,
    broadcast_prefix      => $amqp_broadcast_prefix,
    group_request_prefix  => $amqp_group_request_prefix,
    container_name        => $amqp_container_name,
    idle_timeout          => $amqp_idle_timeout,
    trace                 => $amqp_trace,
    ssl_ca_file           => $amqp_ssl_ca_file,
    ssl_cert_file         => $amqp_ssl_cert_file,
    ssl_key_file          => $amqp_ssl_key_file,
    ssl_key_password      => $amqp_ssl_key_password,
    sasl_mechanisms       => $amqp_sasl_mechanisms,
    sasl_config_dir       => $amqp_sasl_config_dir,
    sasl_config_name      => $amqp_sasl_config_name,
    username              => $amqp_username,
    password              => $amqp_password,
  }

  oslo::messaging::default { 'cinder_config':
    transport_url        => $default_transport_url,
    rpc_response_timeout => $rpc_response_timeout,
    control_exchange     => $control_exchange,
  }

  oslo::messaging::notifications { 'cinder_config':
    transport_url => $notification_transport_url,
    driver        => $notification_driver,
    topics        => $notification_topics,
  }

  if ! $default_availability_zone {
    $default_availability_zone_real = $storage_availability_zone
  } else {
    $default_availability_zone_real = $default_availability_zone
  }

  cinder_config {
    'DEFAULT/report_interval':                   value => $report_interval;
    'DEFAULT/service_down_time':                 value => $service_down_time;
    'DEFAULT/api_paste_config':                  value => $api_paste_config;
    'DEFAULT/storage_availability_zone':         value => $storage_availability_zone;
    'DEFAULT/default_availability_zone':         value => $default_availability_zone_real;
    'DEFAULT/allow_availability_zone_fallback':  value => $allow_availability_zone_fallback;
    'DEFAULT/image_conversion_dir':              value => $image_conversion_dir;
    'DEFAULT/host':                              value => $host;
    'DEFAULT/enable_new_services':               value => $enable_new_services;
    'DEFAULT/enable_force_upload':               value => $enable_force_upload;
    'DEFAULT/cinder_internal_tenant_project_id': value => $cinder_internal_tenant_project_id;
    'DEFAULT/cinder_internal_tenant_user_id':    value => $cinder_internal_tenant_user_id;
  }

  if $backend_host != undef {
    if defined(Class[cinder::backends]){
      fail('The cinder::backend_host parameter has no effect unless cinder::backends is included later')
    }
    warning('The cinder::backend_host parameter is deprecated. \
Use the cinder::backends::backend_host parameter instead')
  }

  if $keymgr_backend != undef {
    warning('The keymgr_backend parameter is deprecated. Use the cinder::key_manager class')
    include cinder::key_manager
  }

  ['keymgr_encryption_api_url', 'keymgr_encryption_auth_url'].each |String $barbican_opt| {
    if getvar("${barbican_opt}") != undef {
      warning("The ${barbican_opt} parameter is deprecated. Use the cinder::key_manager::barbican class")
    }
    include cinder::key_manager::barbican
  }

  oslo::concurrency { 'cinder_config':
    lock_path => $lock_path
  }
}
