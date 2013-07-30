#
class cinder::db::mysql (
  $password,
  $dbname        = 'cinder',
  $user          = 'cinder',
  $host          = '127.0.0.1',
  $allowed_hosts = undef,
  $charset       = 'latin1',
  $cluster_id    = 'localzone'
) {

  Class['cinder::db::mysql'] -> Exec<| title == 'cinder-manage db_sync' |>
  Database[$dbname] ~> Exec<| title == 'cinder-manage db_sync' |>

  mysql::db { $dbname:
    user         => $user,
    password     => $password,
    host         => $host,
    charset      => $charset,
    require      => Class['mysql::config'],
  }

  # Check allowed_hosts to avoid duplicate resource declarations
  if is_array($allowed_hosts) and delete($allowed_hosts,$host) != [] {
    $real_allowed_hosts = delete($allowed_hosts,$host)
  } elsif is_string($allowed_hosts) and ($allowed_hosts != $host) {
    $real_allowed_hosts = $allowed_hosts
  }

  if $real_allowed_hosts {
    # TODO this class should be in the mysql namespace
    cinder::db::mysql::host_access { $real_allowed_hosts:
      user      => $user,
      password  => $password,
      database  => $dbname,
    }
  }

}
