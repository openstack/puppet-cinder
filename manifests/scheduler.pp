#
class cinder::scheduler (
  $package_ensure = 'latest',
  $enabled        = true
) {

  include cinder::params

  package { 'cinder-scheduler':
    name   => $::cinder::params::scheduler_package,
    ensure => $package_ensure,
    require => Class['cinder'],
  }

  if $enabled {
    $ensure = 'running'
  } else {
    $ensure = 'stopped'
  }

  service { $::cinder::params::scheduler_service:
    enable    => $enabled,
    ensure    => $ensure,
    require   => Package[$::cinder::params::scheduler_package],
    subscribe => File[$::cinder::params::cinder_conf],
  }
}
