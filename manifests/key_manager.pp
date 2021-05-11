# == Class: cinder::key_manager
#
# Setup and configure Key Manager options
#
# === Parameters
#
# [*backend*]
#   (Optional) Specify the key manager implementation.
#   Defaults to $::os_service_default
#
class cinder::key_manager (
  $backend = $::os_service_default,
) {

  include cinder::deps

  $backend_real = pick($cinder::keymgr_backend, $backend)

  oslo::key_manager { 'cinder_config':
    backend => $backend_real,
  }
}
