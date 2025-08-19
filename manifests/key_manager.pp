# == Class: cinder::key_manager
#
# Setup and configure Key Manager options
#
# === Parameters
#
# [*backend*]
#   (Optional) Specify the key manager implementation.
#   Defaults to $facts['os_service_default']
#
class cinder::key_manager (
  $backend = $facts['os_service_default'],
) {
  include cinder::deps

  oslo::key_manager { 'cinder_config':
    backend => $backend,
  }
}
