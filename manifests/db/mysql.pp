# == Class: cinder::db::mysql
#
# The cinder::db::mysql class creates a MySQL database for cinder.
# It must be used on the MySQL server
#
# === Parameters
#
# [*password*]
#   password to connect to the database. Mandatory.
#
# [*dbname*]
#   name of the database. Optional. Defaults to cinder.
#
# [*user*]
#   user to connect to the database. Optional. Defaults to cinder.
#
# [*host*]
#   the default source host user is allowed to connect from.
#   Optional. Defaults to 'localhost'
#
# [*allowed_hosts*]
#   other hosts the user is allowd to connect from.
#   Optional. Defaults to undef.
#
# [*charset*]
#   the database charset. Optional. Defaults to 'utf8'
#
# [*collate*]
#   the database collation. Optional. Defaults to 'utf8_general_ci'
#
class cinder::db::mysql (
  $password,
  $dbname        = 'cinder',
  $user          = 'cinder',
  $host          = '127.0.0.1',
  $allowed_hosts = undef,
  $charset       = 'utf8',
  $collate       = 'utf8_general_ci',
) {

  include ::cinder::deps

  validate_string($password)

  ::openstacklib::db::mysql { 'cinder':
    user          => $user,
    password_hash => mysql_password($password),
    dbname        => $dbname,
    host          => $host,
    charset       => $charset,
    collate       => $collate,
    allowed_hosts => $allowed_hosts,
  }

  Anchor['cinder::db::begin']
  ~> Class['cinder::db::mysql']
  ~> Anchor['cinder::db::end']
}
