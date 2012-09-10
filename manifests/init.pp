#
class cinder (
  $keystone_password,
  $cinder_settings        = false,
  $keystone_enabled       = true,
  $keystone_tenant        = 'services',
  $keystone_user          = 'cinder',
  $keystone_auth_host     = 'localhost',
  $keystone_auth_port     = '35357',
  $keystone_auth_protocol = 'http',
  $package_ensure         = 'latest',
) {

  include cinder::params

  package { 'cinder':
    name => $::cinder::params::package_name,
    ensure => $package_ensure,
  }
  
  File { 
    ensure  => present,
    owner   => 'cinder',
    group   => 'cinder',
    mode    => '0644',
    require => Package[$::cinder::params::package_name],
  }

  file { $::cinder::params::cinder_conf: }
  file { $::cinder::params::cinder_paste_api_ini: }

  # Temporary fixes
  file { ['/var/log/cinder', '/var/lib/cinder']:
    ensure => directory,
    owner  => 'cinder',
    group  => 'adm',
  }

  if $cinder_settings {
    multini($::cinder::params::cinder_conf, $cinder_settings)
  }

  if $keystone_enabled {
    multini($::cinder::params::cinder_conf, { 'DEFAULT' => { 'auth_strategy' => 'keystone' } })
    $keystone_settings = {
      'filter:authtoken' => {
        'auth_host'         => $keystone_auth_host,
        'auth_port'         => $keystone_auth_port,
        'auth_protocol'     => $keystone_auth_protocol,
        'admin_user'        => $keystone_user,
        'admin_password'    => $keystone_password,
        'admin_tenant_name' => $keystone_tenant
      }
    }

    multini($::cinder::params::cinder_paste_api_ini, $keystone_settings)
  }

}
