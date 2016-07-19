# == Class: cinder::volume::rbd
#
# Setup Cinder to use the RBD driver.
#
# === Parameters
#
# [*rbd_pool*]
#   (required) Specifies the pool name for the block device driver.
#
# [*rbd_user*]
#   (required) A required parameter to configure OS init scripts and cephx.
#
# [*rbd_ceph_conf*]
#   (optional) Path to the ceph configuration file to use
#   Defaults to '/etc/ceph/ceph.conf'
#
# [*rbd_flatten_volume_from_snapshot*]
#   (optional) Enable flatten volumes created from snapshots.
#   Defaults to $::os_service_default
#
# [*rbd_secret_uuid*]
#   (optional) A required parameter to use cephx.
#   Defaults to $::os_service_default
#
# [*rbd_max_clone_depth*]
#   (optional) Maximum number of nested clones that can be taken of a
#   volume before enforcing a flatten prior to next clone.
#   A value of zero disables cloning
#   Defaults to $::os_service_default
#
# [*rados_connect_timeout*]
#   (optional) Timeout value (in seconds) used when connecting to ceph cluster.
#   If value < 0, no timeout is set and default librados value is used.
#   Defaults to $::os_service_default
#
# [*rados_connection_interval*]
#   (optional) Interval value (in seconds) between connection retries to ceph
#   cluster.
#   Defaults to $::os_service_default
#
# [*rados_connection_retries*]
#   (optional) Number of retries if connection to ceph cluster failed.
#   Defaults to $::os_service_default
#
# [*rbd_store_chunk_size*]
#   (optional) Volumes will be chunked into objects of this size (in megabytes).
#   Defaults to $::os_service_default
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend stanza
#   Defaults to: {}
#   Example :
#     { 'rbd_backend/param1' => { 'value' => value1 } }
#
# === Deprecated Parameters
#
# [*volume_tmp_dir*]
#   (deprecated by image_conversion_dir) Location to store temporary image files
#   if the volume driver does not write them directly to the volume
#   Defaults to false
#
class cinder::volume::rbd (
  $rbd_pool,
  $rbd_user,
  $rbd_ceph_conf                    = '/etc/ceph/ceph.conf',
  $rbd_flatten_volume_from_snapshot = $::os_service_default,
  $rbd_secret_uuid                  = $::os_service_default,
  $rbd_max_clone_depth              = $::os_service_default,
  $rados_connect_timeout            = $::os_service_default,
  $rados_connection_interval        = $::os_service_default,
  $rados_connection_retries         = $::os_service_default,
  $rbd_store_chunk_size             = $::os_service_default,
  $extra_options                    = {},
  # DEPRECATED PARAMETERS
  $volume_tmp_dir                   = false,
) {

  include ::cinder::deps

  warning('Usage of cinder::volume::rbd is deprecated, please use
cinder::backend::rbd instead.')

  cinder::backend::rbd { 'DEFAULT':
    rbd_pool                         => $rbd_pool,
    rbd_user                         => $rbd_user,
    rbd_ceph_conf                    => $rbd_ceph_conf,
    rbd_flatten_volume_from_snapshot => $rbd_flatten_volume_from_snapshot,
    rbd_secret_uuid                  => $rbd_secret_uuid,
    volume_tmp_dir                   => $volume_tmp_dir,
    rbd_max_clone_depth              => $rbd_max_clone_depth,
    rados_connect_timeout            => $rados_connect_timeout,
    rados_connection_interval        => $rados_connection_interval,
    rados_connection_retries         => $rados_connection_retries,
    rbd_store_chunk_size             => $rbd_store_chunk_size,
    extra_options                    => $extra_options,
  }
}
