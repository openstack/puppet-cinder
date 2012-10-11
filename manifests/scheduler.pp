#
class cinder::scheduler (
  $package_ensure = 'latest',
  $enabled        = true
) {

  include cinder::params

  Package['cinder-scheduler'] -> Cinder_config<||>
  Package['cinder-scheduler'] -> Cinder_api_paste_ini<||>
  Cinder_config<||> ~> Service['cinder-scheduler']
  Cinder_api_paste_ini<||> ~> Service['cinder-scheduler']

  package { 'cinder-scheduler':
    name   => $::cinder::params::scheduler_package,
    ensure => $package_ensure,
  }

  if $enabled {
    $ensure = 'running'
  } else {
    $ensure = 'stopped'
  }

  service { 'cinder-scheduler':
    name      => $::cinder::params::scheduler_service,
    enable    => $enabled,
    ensure    => $ensure,
    require   => Package[$::cinder::params::scheduler_package],
    subscribe => File[$::cinder::params::cinder_conf],
  }
}
