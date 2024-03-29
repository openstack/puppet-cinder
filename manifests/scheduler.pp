# == Class: cinder::scheduler
#
#  Scheduler class for cinder.
#
# === Parameters
#
# [*scheduler_driver*]
#   (Optional) Default scheduler driver to use
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
#
class cinder::scheduler (
  $scheduler_driver       = $facts['os_service_default'],
  $package_ensure         = 'present',
  Boolean $enabled        = true,
  Boolean $manage_service = true
) {

  include cinder::deps
  include cinder::params

  cinder_config { 'DEFAULT/scheduler_driver': value => $scheduler_driver; }

  if $::cinder::params::scheduler_package {
    package { 'cinder-scheduler':
      ensure => $package_ensure,
      name   => $::cinder::params::scheduler_package,
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
      name      => $::cinder::params::scheduler_service,
      enable    => $enabled,
      hasstatus => true,
      tag       => 'cinder-service',
    }
  }
}
