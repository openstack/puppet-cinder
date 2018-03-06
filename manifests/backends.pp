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
#   Defaults to hiera('cinder::backend_host', undef)
#
# Author: Andrew Woodward <awoodward@mirantis.com>
class cinder::backends (
  $enabled_backends = undef,
  $backend_host     = hiera('cinder::backend_host', undef)
) {

  include ::cinder::deps

  if $enabled_backends == undef {
    warning("Configurations that are setting backend config in ``[DEFAULT]`` \
section are now not supported. You should use ``enabled_backends``option to  \
set up backends. No volume service(s) started successfully otherwise.")
  } else {
    # Maybe this could be extented to dynamicly find the enabled names
    cinder_config {
      'DEFAULT/enabled_backends': value => join($enabled_backends, ',');
    }
    if $backend_host {
      $enabled_backends.each |$backend| {
        # Avoid colliding with code in backend/rbd.pp
        unless defined(Cinder_config["${backend}/backend_host"]) {
          cinder_config {
            "${backend}/backend_host": value => $backend_host;
          }
        }
      }
    }
  }
}
