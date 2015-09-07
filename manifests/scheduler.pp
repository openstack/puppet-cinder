# == Class: cinder::scheduler
#
#  Scheduler class for cinder.
#
# === Parameters
#
# [*scheduler_driver*]
#   (Optional) Default scheduler driver to use
#   Defaults to '<SERVICE DEFAULT>'.
#
# [*package_ensure*]
#   (Optioanl) The state of the package.
#   Defaults to 'present'.
#
# [*enabled*]
#   (Optional) The state of the service
#   Defaults to 'true'.
#
# [*manage_service*]
#   (Optional) Whether to start/stop the service
#   Defaults to 'true'.
#
#
class cinder::scheduler (
  $scheduler_driver = '<SERVICE DEFAULT>',
  $package_ensure   = 'present',
  $enabled          = true,
  $manage_service   = true
) {

  include ::cinder::params

  Cinder_config<||> ~> Service['cinder-scheduler']
  Cinder_api_paste_ini<||> ~> Service['cinder-scheduler']
  Exec<| title == 'cinder-manage db_sync' |> ~> Service['cinder-scheduler']

  cinder_config { 'DEFAULT/scheduler_driver': value => $scheduler_driver; }

  if $::cinder::params::scheduler_package {
    Package['cinder-scheduler'] -> Service['cinder-scheduler']
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
  }

  service { 'cinder-scheduler':
    ensure    => $ensure,
    name      => $::cinder::params::scheduler_service,
    enable    => $enabled,
    hasstatus => true,
    require   => Package['cinder'],
    tag       => 'cinder-service',
  }
}
