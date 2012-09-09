#
class cinder::volume (
  $package_ensure = 'latest',
  $enabled        = true
) {

  include cinder::params

  package { 'cinder-volume':
    name   => $::cinder::params::volume_package,
    ensure => $package_ensure,
    require => Class['cinder'],
  }

  if $enabled {
    $ensure = 'running'
  } else {
    $ensure = 'stopped'
  }

  service { $::cinder::params::volume_service:
    enable    => $enabled,
    ensure    => $ensure,
    require   => Package[$::cinder::params::volume_package],
    subscribe => File[$::cinder::params::cinder_conf],
  }
}
