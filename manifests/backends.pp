# == Class: cinder::backends
#
# Class to set the enabled_backends list
#
# === Parameters
#
# [*enabled_backends*]
#   (Required) a list of ini sections to enable.
#   This should contain names used in cinder::backend::* resources.
#   Example: ['volume1', 'volume2', 'sata3']
#   Defaults to undef
#
# [*backend_host*]
#   (optional) Backend override of host value.
#   Defaults to $facts['os_service_default']
#
# Author: Andrew Woodward <awoodward@mirantis.com>
class cinder::backends (
  Array[String[1], 1] $enabled_backends,
  $backend_host     = $facts['os_service_default'],
) {

  include cinder::deps

  # Maybe this could be extended to dynamically find the enabled names
  cinder_config {
    'DEFAULT/enabled_backends': value => join($enabled_backends, ',');
  }

  $enabled_backends.each |$backend| {
    # Avoid colliding with code in backend/rbd.pp
    unless defined(Cinder_config["${backend}/backend_host"]) {
      cinder_config {
        "${backend}/backend_host": value => $backend_host;
      }
    }
  }
}
