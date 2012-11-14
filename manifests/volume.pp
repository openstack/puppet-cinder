# $volume_name_template = volume-%s
class cinder::volume (
  $package_ensure = 'latest',
  $enabled        = true
) {

  include cinder::params

  Cinder_config<||> ~> Service['cinder-volume']
  Cinder_api_paste_ini<||> ~> Service['cinder-volume']

  if $::cinder::params::volume_package {
    Package['cinder-volume'] -> Cinder_config<||>
    Package['cinder-volume'] -> Cinder_api_paste_ini<||>
    Package['cinder']        -> Package['cinder-volume']
    Package['cinder-volume'] -> Service['cinder-volume']
    package { 'cinder-volume':
      name   => $::cinder::params::volume_package,
      ensure => $package_ensure,
    }
  }

  if $enabled {
    $ensure = 'running'
  } else {
    $ensure = 'stopped'
  }

  service { 'cinder-volume':
    name      => $::cinder::params::volume_service,
    enable    => $enabled,
    ensure    => $ensure,
    require   => Package['cinder'],
    subscribe => File[$::cinder::params::cinder_conf],
  }

}
