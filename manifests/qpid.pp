# == Class: cinder::qpid
#
# Deprecated class for installing qpid server for cinder
#
# === Parameters
#
# [*enabled*]
#   (Optional) Whether to enable the qpid service.
#   Defaults to undef.
#
# [*user*]
#   (Optional) The username to use when connecting to qpid.
#   Defaults to undef.
#
# [*password*]
#   (Optional) The password to use when connecting to qpid
#   Defaults to undef.
#
# [*file*]
#   (Optional) The SASL database.
#   Defaults to undef.
#
# [*realm*]
#   (Optional) The Realm for qpid.
#   Defaults to undef.
#
class cinder::qpid (
  $enabled  = undef,
  $user     = undef,
  $password = undef,
  $file     = undef,
  $realm    = undef
) {

  warning('Qpid driver is removed from Oslo.messaging in the Mitaka release')
}
