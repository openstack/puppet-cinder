#
# Class to execute cinder dbsync
#
class cinder::db::sync {

  include ::cinder::params

  Package <| tag == 'cinder-package' |> ~> Exec['cinder-manage db_sync']
  Exec['cinder-manage db_sync'] ~> Service <| tag == 'cinder-service' |>

  Cinder_config <||> ~> Exec['cinder-manage db_sync']
  Cinder_config <| title == 'database/connection' |> ~> Exec['cinder-manage db_sync']

  exec { 'cinder-manage db_sync':
    command     => $::cinder::params::db_sync_command,
    path        => '/usr/bin',
    user        => 'cinder',
    refreshonly => true,
    logoutput   => 'on_failure',
  }

}
