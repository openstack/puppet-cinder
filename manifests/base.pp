#
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
  $verbose                = false
) {

  warning('The cinder::base class is deprecated. Use cinder instead.')

  class { 'cinder':
    rabbit_password         => $rabbit_password,
    sql_connection          => $sql_connection,
    rabbit_host             => $rabbit_host,
    rabbit_port             => $rabbit_port,
    rabbit_hosts            => $rabbit_hosts,
    rabbit_virtual_host     => $rabbit_virtual_host,
    rabbit_userid           => $rabbit_userid,
    package_ensure          => $package_ensure,
    api_paste_config        => $api_paste_config,
    verbose                 => $verbose,
  }

}
