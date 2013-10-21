# == Class: cinder::volume::rbd
#
# Setup Cinder to use the RBD driver.
#
# === Parameters
#
# [*rbd_pool*]
#   (required) Specifies the pool name for the block device driver.
#
# [*glance_api_version*]
#   (required) Required for Ceph functionality.
#
# [*rbd_user*]
#   (required) A required parameter to configure OS init scripts and cephx.
#
# [*rbd_secret_uuid*]
#   (optional) A required parameter to use cephx.
#


class cinder::volume::rbd (
  $rbd_pool,
  $glance_api_version = '2',
  $rbd_user,
  $rbd_secret_uuid    = false,
) {

  include cinder::params

  cinder_config {
    'DEFAULT/volume_driver':        value =>
      'cinder.volume.drivers.rbd.RBDDriver';
    'DEFAULT/glance_api_version':   value => $glance_api_version;
    'DEFAULT/rbd_user':             value => $rbd_user;
    'DEFAULT/rbd_pool':             value => $rbd_pool;
  }
  if $rbd_secret_uuid {
    cinder_config {
      'DEFAULT/rbd_secret_uuid':    value => $rbd_secret_uuid;
    }
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
