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
#   (optional) Enalbe flatten volumes created from snapshots.
#   Defaults to false
#
# [*rbd_secret_uuid*]
#   (optional) A required parameter to use cephx.
#   Defaults to false
#
# [*volume_tmp_dir*]
#   (optional) Location to store temporary image files if the volume
#   driver does not write them directly to the volume
#   Defaults to false
#
# [*rbd_max_clone_depth*]
#   (optional) Maximum number of nested clones that can be taken of a
#   volume before enforcing a flatten prior to next clone.
#   A value of zero disables cloning
#   Defaults to '5'
#
# [*glance_api_version*]
#   (optional) DEPRECATED: Use cinder::glance Class instead.
#   Glance API version. (Defaults to '2')
#   Setting this parameter cause a duplicate resource declaration
#   with cinder::glance
#
class cinder::volume::rbd (
  $rbd_pool,
  $rbd_user,
  $rbd_ceph_conf                    = '/etc/ceph/ceph.conf',
  $rbd_flatten_volume_from_snapshot = false,
  $rbd_secret_uuid                  = false,
  $volume_tmp_dir                   = false,
  $rbd_max_clone_depth              = '5',
  # DEPRECATED PARAMETERS
  $glance_api_version               = undef,
) {

  include cinder::params

  if $glance_api_version {
    warning('The glance_api_version is deprecated, use glance_api_version of cinder::glance class instead.')
  }

  cinder_config {
    'DEFAULT/volume_driver':                    value => 'cinder.volume.drivers.rbd.RBDDriver';
    'DEFAULT/rbd_ceph_conf':                    value => $rbd_ceph_conf;
    'DEFAULT/rbd_user':                         value => $rbd_user;
    'DEFAULT/rbd_pool':                         value => $rbd_pool;
    'DEFAULT/rbd_max_clone_depth':              value => $rbd_max_clone_depth;
    'DEFAULT/rbd_secret_uuid':                  value => $rbd_secret_uuid;
    'DEFAULT/rbd_flatten_volume_from_snapshot': value => $rbd_flatten_volume_from_snapshot;
    'DEFAULT/volume_tmp_dir':                   value => $volume_tmp_dir;

  }

  case $::osfamily {
    'Debian': {
      $override_line    = "env CEPH_ARGS=\"--id ${rbd_user}\""
    }
    'RedHat': {
      $override_line    = "export CEPH_ARGS=\"--id ${rbd_user}\""
    }
    default: {
      fail("unsuported osfamily ${::osfamily}, currently Debian and Redhat are the only supported platforms")
    }
  }

  # Creates an empty file if it doesn't yet exist
  file { $::cinder::params::ceph_init_override:
    ensure  => present,
  }

  file_line { 'set initscript env':
    line    => $override_line,
    path    => $::cinder::params::ceph_init_override,
    notify  => Service['cinder-volume'],
  }

}
