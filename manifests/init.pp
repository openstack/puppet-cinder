#
# parameters that may need to be added
# $state_path = /opt/stack/data/cinder
# $osapi_volume_extension = cinder.api.openstack.volume.contrib.standard_extensions
# $root_helper = sudo /usr/local/bin/cinder-rootwrap /etc/cinder/rootwrap.conf
class cinder (
  $sql_connection,
  $rpc_backend                 = 'cinder.openstack.common.rpc.impl_kombu',
  $rabbit_host                 = '127.0.0.1',
  $rabbit_port                 = 5672,
  $rabbit_hosts                = undef,
  $rabbit_virtual_host         = '/',
  $rabbit_userid               = 'guest',
  $rabbit_password             = false,
  $qpid_hostname               = 'localhost',
  $qpid_port                   = '5672',
  $qpid_username               = 'guest',
  $qpid_password               = false,
  $qpid_reconnect              = true,
  $qpid_reconnect_timeout      = 0,
  $qpid_reconnect_limit        = 0,
  $qpid_reconnect_interval_min = 0,
  $qpid_reconnect_interval_max = 0,
  $qpid_reconnect_interval     = 0,
  $qpid_heartbeat              = 60,
  $qpid_protocol               = 'tcp',
  $qpid_tcp_nodelay            = true,
  $package_ensure              = 'present',
  $api_paste_config            = '/etc/cinder/api-paste.ini',
  $verbose                     = 'False'
) {

  include cinder::params

  Package['cinder'] -> Cinder_config<||>
  Package['cinder'] -> Cinder_api_paste_ini<||>

  # this anchor is used to simplify the graph between cinder components by
  # allowing a resource to serve as a point where the configuration of cinder begins
  anchor { 'cinder-start': }

  package { 'cinder':
    name => $::cinder::params::package_name,
    ensure => $package_ensure,
    require => Anchor['cinder-start'],
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

  if $rpc_backend == 'cinder.openstack.common.rpc.impl_kombu' {

    if ! $rabbit_password {
      fail('Please specify a rabbit_password parameter.')
    }

    cinder_config {
      'DEFAULT/rabbit_password':     value => $rabbit_password;
      'DEFAULT/rabbit_userid':       value => $rabbit_userid;
      'DEFAULT/rabbit_virtual_host': value => $rabbit_virtual_host;
    }

    if size($rabbit_hosts) > 1 {
      cinder_config { 'DEFAULT/rabbit_ha_queues': value => 'true' }
    } else {
      cinder_config { 'DEFAULT/rabbit_ha_queues': value => 'false' }
    }

    if $rabbit_hosts {
      cinder_config { 'DEFAULT/rabbit_hosts': value => join($rabbit_hosts, ',') }
    } elsif $rabbit_host {
      cinder_config { 'DEFAULT/rabbit_host': value => $rabbit_host }
      cinder_config { 'DEFAULT/rabbit_port': value => $rabbit_port }
      cinder_config { 'DEFAULT/rabbit_hosts': value => "${rabbit_host}:${rabbit_port}" }
    }
  }

  if $rpc_backend == 'cinder.openstack.common.rpc.impl_qpid' {

    if ! $qpid_password {
      fail('Please specify a qpid_password parameter.')
    }

    cinder_config {
      'DEFAULT/qpid_hostname':               value => $qpid_hostname;
      'DEFAULT/qpid_port':                   value => $qpid_port;
      'DEFAULT/qpid_username':               value => $qpid_username;
      'DEFAULT/qpid_password':               value => $qpid_password;
      'DEFAULT/qpid_reconnect':              value => $qpid_reconnect;
      'DEFAULT/qpid_reconnect_timeout':      value => $qpid_reconnect_timeout;
      'DEFAULT/qpid_reconnect_limit':        value => $qpid_reconnect_limit;
      'DEFAULT/qpid_reconnect_interval_min': value => $qpid_reconnect_interval_min;
      'DEFAULT/qpid_reconnect_interval_max': value => $qpid_reconnect_interval_max;
      'DEFAULT/qpid_reconnect_interval':     value => $qpid_reconnect_interval;
      'DEFAULT/qpid_heartbeat':              value => $qpid_heartbeat;
      'DEFAULT/qpid_protocol':               value => $qpid_protocol;
      'DEFAULT/qpid_tcp_nodelay':            value => $qpid_tcp_nodelay;
    }
  }

  cinder_config {
    'DEFAULT/sql_connection':      value => $sql_connection;
    'DEFAULT/verbose':             value => $verbose;
    'DEFAULT/api_paste_config':    value => $api_paste_config;
    'DEFAULT/rpc_backend':         value => $rpc_backend;
  }

}
