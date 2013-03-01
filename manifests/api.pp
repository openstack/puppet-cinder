#
class cinder::api (
  $keystone_password,
  $keystone_enabled       = true,
  $keystone_tenant        = 'services',
  $keystone_user          = 'cinder',
  $keystone_auth_host     = 'localhost',
  $keystone_auth_port     = '35357',
  $keystone_auth_protocol = 'http',
  $service_port           = '5000',
  $package_ensure         = 'latest',
  $bind_host              = '0.0.0.0',
  $enabled                = true
) {

  include cinder::params

  Cinder_config<||> ~> Service['cinder-api']
  Cinder_config<||> ~> Exec['cinder-manage db_sync']
  Cinder_api_paste_ini<||> ~> Service['cinder-api']

  if $::cinder::params::api_package {
    Package['cinder-api'] -> Cinder_config<||>
    Package['cinder-api'] -> Cinder_api_paste_ini<||>
    Package['cinder-api'] -> Service['cinder-api']
    package { 'cinder-api':
      name    => $::cinder::params::api_package,
      ensure  => $package_ensure,
    }
  }

  if $enabled {
    $ensure = 'running'
  } else {
    $ensure = 'stopped'
  }

  service { 'cinder-api':
    name      => $::cinder::params::api_service,
    enable    => $enabled,
    ensure    => $ensure,
    require   => Package['cinder'],
  }

  cinder_config {
    'DEFAULT/bind_host': value => $bind_host
  }

  if $keystone_enabled {
    cinder_config {
      'DEFAULT/auth_strategy':     value => 'keystone' ;
    }
    cinder_api_paste_ini {
      'filter:authtoken/service_protocol':  value => $keystone_auth_protocol;
      'filter:authtoken/service_host':      value => $keystone_auth_host;
      'filter:authtoken/service_port':      value => $service_port;
      'filter:authtoken/auth_protocol':     value => $keystone_auth_protocol;
      'filter:authtoken/auth_host':         value => $keystone_auth_host;
      'filter:authtoken/auth_port':         value => $keystone_auth_port;
      'filter:authtoken/admin_tenant_name': value => $keystone_tenant;
      'filter:authtoken/admin_user':        value => $keystone_user;
      'filter:authtoken/admin_password':    value => $keystone_password;
    }
  }

  exec { 'cinder-manage db_sync':
    command     => $::cinder::params::db_sync_command,
    path        => '/usr/bin',
    user        => 'cinder',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

}
