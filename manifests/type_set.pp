# ==Define: cinder::type_set
#
# Assigns keys after the volume type is set.
# Deprecated class.
#
# === Parameters
#
# [*type*]
#   (required) Accepts single name of type to set.
#
# [*key*]
#   (required) the key name that we are setting the value for.
#
# [*value*]
#   the value that we are setting. Defaults to content of namevar.
#
# Author: Andrew Woodward <awoodward@mirantis.com>
#
define cinder::type_set (
  $type,
  $key,
  $value = $name,
) {

  include ::cinder::deps

  cinder_type { $type:
    ensure     => present,
    properties => ["${key}=${value}"],
  }
}
