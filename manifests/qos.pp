# == Define: cinder::qos
#
# DEPRECATED !
# Creates cinder QOS and assigns properties and volume type
#
# === Parameters
#
# [*associations*]
#   (optional) List of cinder type associated with this QOS
#   Defaults to 'undef'.
#
# [*consumer*]
#   (optional) QOS consumer parameter (typicaly front-end/back-end/both)
#   Defaults to 'undef'.
#
# [*properties*]
#   (optional) List QOS properties
#   Defaults to 'undef'.
#
define cinder::qos (
  $associations = undef,
  $consumer     = undef,
  $properties   = undef,
) {

  include cinder::deps

  warning('The cinder::qos resource type is deprecated, please use the cinder_qos resource.')

  cinder_qos { $name:
    ensure       => present,
    properties   => $properties,
    consumer     => $consumer,
    associations => $associations,
  }
}
