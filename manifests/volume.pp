# $volume_name_template = volume-%s
class cinder::volume (
  $package_ensure = 'latest',
  $enabled        = true
) {

  include cinder::params

  Package['cinder-volume'] -> Cinder_config<||>
  Package['cinder-volume'] -> Cinder_api_paste_ini<||>
  Package['cinder']        -> Package['cinder-volume']
  Cinder_config<||> ~> Service['cinder-volume']
  Cinder_api_paste_ini<||> ~> Service['cinder-volume']

  package { 'cinder-volume':
    name   => $::cinder::params::volume_package,
    ensure => $package_ensure,
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
    require   => Package['cinder-volume'],
    subscribe => File[$::cinder::params::cinder_conf],
  }

}
