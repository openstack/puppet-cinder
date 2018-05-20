# == Define: cinder::type
#
# Creates cinder type and assigns backends.
# Deprecated class.
#
# === Parameters
#
# [*set_key*]
#   (Optional) Must be used with set_value. Accepts a single string be used
#   as the key in type_set
#   Defaults to 'undef'.
#
# [*set_value*]
#   (optional) Accepts list of strings or singular string. A list of values
#   passed to type_set
#   Defaults to 'undef'.
#
# Author: Andrew Woodward <awoodward@mirantis.com>
#
define cinder::type (
  $set_key   = undef,
  $set_value = undef,
) {

  include ::cinder::deps

  if ($set_value and $set_key) {
    if is_array($set_value) {
      $value = join($set_value, ',')
    } else {
      $value = $set_value
    }
    cinder_type { $name:
      ensure     => present,
      properties => ["${set_key}=${value}"],
    }
  } else {
    cinder_type { $name:
      ensure => present,
    }
  }
}
