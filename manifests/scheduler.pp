# == Class: cinder::scheduler
#
#  Scheduler class for cinder.
#
# === Parameters
#
# [*driver*]
#   (Optional) Default scheduler driver to use
#   Defaults to $facts['os_service_default'].
#
# [*driver_init_wait_time*]
#   (Optional) Maximum time in seconds to wait for the driver to report as
#   ready.
#   Defaults to $facts['os_service_default'].
#
# [*host_manager*]
#   (Optional) The scheduler host manager class to use.
#   Defaults to $facts['os_service_default'].
#
# [*max_attempts*]
#   (Optional) Maximum number of attempts to schedule a volume.
#   Defaults to $facts['os_service_default'].
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
# DEPRECATED PARAMETERS
#
# [*scheduler_driver*]
#   (Optional) Default scheduler driver to use
#   Defaults to undef
#
class cinder::scheduler (
  $driver                                 = $facts['os_service_default'],
  $driver_init_wait_time                  = $facts['os_service_default'],
  $host_manager                           = $facts['os_service_default'],
  $max_attempts                           = $facts['os_service_default'],
  Stdlib::Ensure::Package $package_ensure = 'present',
  Boolean $enabled                        = true,
  Boolean $manage_service                 = true,
  # DEPRECATED PARAMETERS
  $scheduler_driver                       = undef
) {
  include cinder::deps
  include cinder::params

  if $scheduler_driver != undef {
    warning("The scheduler_driver parameter has been deprecated. \
Use the driver parameter instead")
    $driver_real = $scheduler_driver
  } else {
    $driver_real = $driver
  }

  cinder_config {
    'DEFAULT/scheduler_driver':                value => $driver_real;
    'DEFAULT/scheduler_driver_init_wait_time': value => $driver_init_wait_time;
    'DEFAULT/scheduler_host_manager':          value => $host_manager;
    'DEFAULT/scheduler_max_attempts':          value => $max_attempts;
  }

  if $cinder::params::scheduler_package {
    package { 'cinder-scheduler':
      ensure => $package_ensure,
      name   => $cinder::params::scheduler_package,
      tag    => ['openstack', 'cinder-package'],
    }
  }

  if $manage_service {
    if $enabled {
      $ensure = 'running'
    } else {
      $ensure = 'stopped'
    }

    service { 'cinder-scheduler':
      ensure    => $ensure,
      name      => $cinder::params::scheduler_service,
      enable    => $enabled,
      hasstatus => true,
      tag       => 'cinder-service',
    }
  }
}
