# == Class: cinder::volume
#
# === Parameters
#
# [*package_ensure*]
#   (Optional) The state of the package.
#   Defaults to 'present'.
#
# [*enabled*]
#   (Optional) The state of the service (boolean value)
#   Defaults to true.
#
# [*manage_service*]
#   (Optional) Whether to start/stop the service (boolean value)
#   Defaults to true.
#
# [*cluster*]
#   (Optional) Cluster name when running in active/active mode.
#   Defaults to $facts['os_service_default'].
#
# [*volume_clear*]
#   (Optional) Method used to wipe old volumes.
#   Defaults to $facts['os_service_default'].
#
# [*volume_clear_size*]
#   (Optional) Size in MiB to wipe at start of old volumes.
#   Set to '0' means all.
#   Defaults to $facts['os_service_default'].
#
# [*volume_clear_ionice*]
#   (Optional) The flag to pass to ionice to alter the i/o priority
#   of the process used to zero a volume after deletion,
#   for example "-c3" for idle only priority.
#   Defaults to $facts['os_service_default'].
#
# [*migration_create_volume_timeout_secs*]
#   (Optional) Timeout for creating the volume to migrate to when performing
#   volume migration (seconds).
#   Defaults to $facts['os_service_default'].
#
# [*volume_service_inithost_offload*]
#   (Optional) Offload pending volume delete during volume service startup.
#   Defaults to $facts['os_service_default'].
#
# [*reinit_driver_count*]
#   (Optional) Maximum times to reinitialize the driver if volume
#   initialization fails.
#   Defaults to $facts['os_service_default'].
#
# [*init_host_max_objects_retrieval*]
#   (Optional) Max number of volumes and snapshots to be retrieved per batch
#   during volume manager host initialization.
#   Defaults to $facts['os_service_default'].
#
# [*backend_stats_polling_interval*]
#   (Optional) Time in seconds between requests for usage statistics from
#   the backend.
#   Defaults to $facts['os_service_default'].
#
class cinder::volume (
  $package_ensure                       = 'present',
  Boolean $enabled                      = true,
  Boolean $manage_service               = true,
  $cluster                              = $facts['os_service_default'],
  $volume_clear                         = $facts['os_service_default'],
  $volume_clear_size                    = $facts['os_service_default'],
  $volume_clear_ionice                  = $facts['os_service_default'],
  $migration_create_volume_timeout_secs = $facts['os_service_default'],
  $volume_service_inithost_offload      = $facts['os_service_default'],
  $reinit_driver_count                  = $facts['os_service_default'],
  $init_host_max_objects_retrieval      = $facts['os_service_default'],
  $backend_stats_polling_interval       = $facts['os_service_default'],
) {
  include cinder::deps
  include cinder::params

  if $cinder::params::volume_package {
    package { 'cinder-volume':
      ensure => $package_ensure,
      name   => $cinder::params::volume_package,
      tag    => ['openstack', 'cinder-package'],
    }
  }

  if $manage_service {
    if $enabled {
      $ensure = 'running'
    } else {
      $ensure = 'stopped'
    }

    service { 'cinder-volume':
      ensure    => $ensure,
      name      => $cinder::params::volume_service,
      enable    => $enabled,
      hasstatus => true,
      tag       => 'cinder-service',
    }
  }

  cinder_config {
    'DEFAULT/cluster':                              value => $cluster;
    'DEFAULT/volume_clear':                         value => $volume_clear;
    'DEFAULT/volume_clear_size':                    value => $volume_clear_size;
    'DEFAULT/volume_clear_ionice':                  value => $volume_clear_ionice;
    'DEFAULT/migration_create_volume_timeout_secs': value => $migration_create_volume_timeout_secs;
    'DEFAULT/volume_service_inithost_offload':      value => $volume_service_inithost_offload;
    'DEFAULT/reinit_driver_count':                  value => $reinit_driver_count;
    'DEFAULT/init_host_max_objects_retrieval':      value => $init_host_max_objects_retrieval;
    'DEFAULT/backend_stats_polling_interval':       value => $backend_stats_polling_interval;
  }
}
