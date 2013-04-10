#
# parameters that may need to be added
# $state_path = /opt/stack/data/cinder
# $osapi_volume_extension = cinder.api.openstack.volume.contrib.standard_extensions
# $root_helper = sudo /usr/local/bin/cinder-rootwrap /etc/cinder/rootwrap.conf
class cinder::base (
  $rabbit_password,
  $sql_connection,
  $rabbit_host            = '127.0.0.1',
  $rabbit_port            = 5672,
  $rabbit_hosts           = undef,
  $rabbit_virtual_host    = '/',
  $rabbit_userid          = 'nova',
  $package_ensure         = 'present',
  $api_paste_config       = '/etc/cinder/api-paste.ini',
  $verbose                = 'False'
) {

  include cinder::params

  Package['cinder'] -> Cinder_config<||>
  Package['cinder'] -> Cinder_api_paste_ini<||>

  package { 'cinder':
    name => $::cinder::params::package_name,
    ensure => $package_ensure,
  }

  file { $::cinder::params::cinder_conf:
    ensure  => present,
    owner   => 'cinder',
    group   => 'cinder',
    mode    => '0600',
    require => Package[$::cinder::params::package_name],
  }

  file { $::cinder::params::cinder_paste_api_ini:
    ensure  => present,
    owner   => 'cinder',
    group   => 'cinder',
    mode    => '0600',
    require => Package[$::cinder::params::package_name],
  }

  if $rabbit_hosts {
    cinder_config {
      'DEFAULT/rabbit_hosts':        value => join($rabbit_hosts, ',');
    }
  } else {
    cinder_config {
      'DEFAULT/rabbit_host':        value => $rabbit_host;
      'DEFAULT/rabbit_port':        value => $rabbit_port;
      'DEFAULT/rabbit_hosts':       value => "$rabbit_host:$rabbit_port";
    }
  }

  cinder_config {
    'DEFAULT/rabbit_password':     value => $rabbit_password;
    'DEFAULT/rabbit_virtual_host': value => $rabbit_virtual_host;
    'DEFAULT/rabbit_userid':       value => $rabbit_userid;
    'DEFAULT/sql_connection':      value => $sql_connection;
    'DEFAULT/verbose':             value => $verbose;
    'DEFAULT/api_paste_config':    value => $api_paste_config;
  }

  if size($rabbit_hosts) > 1 {
    cinder_config { 'DEFAULT/rabbit_ha_queues': value => 'true' }
  } else {
    cinder_config { 'DEFAULT/rabbit_ha_queues': value => 'false' }
  }

}
