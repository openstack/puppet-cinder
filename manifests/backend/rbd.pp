# == define: cinder::backend::rbd
#
# Setup Cinder to use the RBD driver.
# Compatible for multiple backends
#
# === Parameters
#
# [*rbd_pool*]
#   (required) Specifies the pool name for the block device driver.
#
# [*rbd_user*]
#   (required) A required parameter to configure OS init scripts and cephx.
#
# [*backend_host*]
#   (optional) Allows specifying the hostname/key used for the owner of volumes
#   created.  This must be set to the same value on all nodes in a multi-node
#   environment.
#   Defaults to 'rbd:<rbd_pool>'
#
# [*volume_backend_name*]
#   (optional) Allows for the volume_backend_name to be separate of $name.
#   Defaults to: $name
#
# [*backend_availability_zone*]
#   (Optional) Availability zone for this volume backend.
#   If not set, the storage_availability_zone option value
#   is used as the default for all backends.
#   Defaults to $facts['os_service_default'].
#
# [*reserved_percentage*]
#   (Optional) The percentage of backend capacity is reserved.
#   Defaults to $facts['os_service_default'].
#
# [*max_over_subscription_ratio*]
#   (Optional) Representation of the over subscription ratio when thin
#   provisionig is involved.
#   Defaults to $facts['os_service_default'].
#
# [*rbd_ceph_conf*]
#   (optional) Path to the ceph configuration file to use
#   Defaults to '/etc/ceph/ceph.conf'
#
# [*rbd_flatten_volume_from_snapshot*]
#   (optional) Enable flatten volumes created from snapshots.
#   Defaults to false
#
# [*rbd_secret_uuid*]
#   (optional) A required parameter to use cephx.
#   Defaults to $facts['os_service_default']
#
# [*rbd_max_clone_depth*]
#   (optional) Maximum number of nested clones that can be taken of a
#   volume before enforcing a flatten prior to next clone.
#   A value of zero disables cloning
#   Defaults to $facts['os_service_default']
#
# [*rados_connect_timeout*]
#   (optional) Timeout value (in seconds) used when connecting to ceph cluster.
#   If value < 0, no timeout is set and default librados value is used.
#   Defaults to $facts['os_service_default']
#
# [*rados_connection_interval*]
#   (optional) Interval value (in seconds) between connection retries to ceph
#   cluster.
#   Defaults to $facts['os_service_default']
#
# [*rados_connection_retries*]
#   (optional) Number of retries if connection to ceph cluster failed.
#   Defaults to $facts['os_service_default']
#
# [*rbd_store_chunk_size*]
#   (optional) Volumes will be chunked into objects of this size (in megabytes).
#   Defaults to $facts['os_service_default']
#
# [*report_dynamic_total_capacity*]
#   (optional) Set to True for driver to report total capacity as a dynamic
#   value
#   Defaults to $facts['os_service_default']
#
# [*rbd_exclusive_cinder_pool*]
#   (optional) Set to True if the pool is used exclusively by Cinder.
#   Defaults to $facts['os_service_default']
#
# [*enable_deferred_deletion*]
#   (optional) Enable deferred deletion. Upon deletion, volumes are tagged for
#   deletion but will only be removed asynchronously at a later time.
#   Defaults to $facts['os_service_default']
#
# [*deferred_deletion_delay*]
#   (optional) Time delay in seconds before a volume is eligible for permanent
#   removal after being tagged for deferred deletion.
#   Defaults to $facts['os_service_default']
#
# [*deferred_deletion_purge_interval*]
#   (optional) Number of seconds between runs of the periodic task to purge
#   volumes tagged for deletion.
#   Defaults to $facts['os_service_default']
#
# [*rbd_concurrent_flatten_operations*]
#   (optional) Number of flatten operations that will run concurrently on
#   this volume service.
#   Defaults to $facts['os_service_default']
#
# [*manage_volume_type*]
#   (Optional) Whether or not manage Cinder Volume type.
#   If set to true, a Cinder Volume type will be created
#   with volume_backend_name=$volume_backend_name key/value.
#   Defaults to false.
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend stanza
#   Defaults to: {}
#   Example :
#     { 'rbd_backend/param1' => { 'value' => value1 } }
#
define cinder::backend::rbd (
  $rbd_pool,
  $rbd_user,
  $backend_host                      = undef,
  $volume_backend_name               = $name,
  $backend_availability_zone         = $facts['os_service_default'],
  $reserved_percentage               = $facts['os_service_default'],
  $max_over_subscription_ratio       = $facts['os_service_default'],
  $rbd_ceph_conf                     = '/etc/ceph/ceph.conf',
  $rbd_flatten_volume_from_snapshot  = $facts['os_service_default'],
  $rbd_secret_uuid                   = $facts['os_service_default'],
  $rbd_max_clone_depth               = $facts['os_service_default'],
  $rados_connect_timeout             = $facts['os_service_default'],
  $rados_connection_interval         = $facts['os_service_default'],
  $rados_connection_retries          = $facts['os_service_default'],
  $rbd_store_chunk_size              = $facts['os_service_default'],
  $report_dynamic_total_capacity     = $facts['os_service_default'],
  $rbd_exclusive_cinder_pool         = $facts['os_service_default'],
  $enable_deferred_deletion          = $facts['os_service_default'],
  $deferred_deletion_delay           = $facts['os_service_default'],
  $deferred_deletion_purge_interval  = $facts['os_service_default'],
  $rbd_concurrent_flatten_operations = $facts['os_service_default'],
  Boolean $manage_volume_type        = false,
  Hash $extra_options                = {},
) {

  include cinder::deps
  include cinder::params

  $rbd_cluster_name = basename($rbd_ceph_conf, '.conf')
  if $rbd_cluster_name == 'ceph' {
    # Do not pass a parameter value in order to avoid service restarts
    $rbd_cluster_name_real = undef
  } else {
    $rbd_cluster_name_real = $rbd_cluster_name
  }

  cinder_config {
    "${name}/volume_backend_name":               value => $volume_backend_name;
    "${name}/backend_availability_zone":         value => $backend_availability_zone;
    "${name}/reserved_percentage":               value => $reserved_percentage;
    "${name}/max_over_subscription_ratio":       value => $max_over_subscription_ratio;
    "${name}/volume_driver":                     value => 'cinder.volume.drivers.rbd.RBDDriver';
    "${name}/rbd_ceph_conf":                     value => $rbd_ceph_conf;
    "${name}/rbd_user":                          value => $rbd_user;
    "${name}/rbd_pool":                          value => $rbd_pool;
    "${name}/rbd_max_clone_depth":               value => $rbd_max_clone_depth;
    "${name}/rbd_flatten_volume_from_snapshot":  value => $rbd_flatten_volume_from_snapshot;
    "${name}/rbd_secret_uuid":                   value => $rbd_secret_uuid;
    "${name}/rados_connect_timeout":             value => $rados_connect_timeout;
    "${name}/rados_connection_interval":         value => $rados_connection_interval;
    "${name}/rados_connection_retries":          value => $rados_connection_retries;
    "${name}/rbd_store_chunk_size":              value => $rbd_store_chunk_size;
    "${name}/rbd_cluster_name":                  value => $rbd_cluster_name_real;
    "${name}/report_dynamic_total_capacity":     value => $report_dynamic_total_capacity;
    "${name}/rbd_exclusive_cinder_pool":         value => $rbd_exclusive_cinder_pool;
    "${name}/enable_deferred_deletion":          value => $enable_deferred_deletion;
    "${name}/deferred_deletion_delay":           value => $deferred_deletion_delay;
    "${name}/deferred_deletion_purge_interval":  value => $deferred_deletion_purge_interval;
    "${name}/rbd_concurrent_flatten_operations": value => $rbd_concurrent_flatten_operations;
    "${name}/report_discard_supported":          value => true;
  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => ["volume_backend_name=${volume_backend_name}"],
    }
  }

  # Avoid colliding with code in backends.pp
  unless defined(Cinder_config["${name}/backend_host"]) {
    if $backend_host {
      cinder_config {
        "${name}/backend_host": value => $backend_host;
      }
    } else {
      cinder_config {
        "${name}/backend_host": value => "rbd:${rbd_pool}";
      }
    }
  }

  ensure_packages( 'ceph-common', {
    ensure => present,
    name   => $::cinder::params::ceph_common_package_name,
    tag    => 'cinder-support-package'})

  create_resources('cinder_config', $extra_options)
}
