#
class cinder::db::mysql (
  $password,
  $dbname = 'cinder',
  $user   = 'cinder',
) {

  include cinder::params

  Class['cinder::db::mysql'] -> Class['cinder::db::sync']
  Database[$dbname] ~> Exec<| title == 'cinder-manage db_sync' |>

  mysql::db { $dbname:
    host     => '127.0.0.1',
    user     => $user,
    password => $password,
  }
}
