# == Class: cinder::coordination
#
# Setup and configure Cinder coordination settings.
#
# === Parameters
#
# [*backend_url*]
#   (Optional) Coordination backend URL.
#   Defaults to $facts['os_service_default']
#
class cinder::coordination (
  $backend_url = $facts['os_service_default'],
) {
  include cinder::deps

  oslo::coordination { 'cinder_config':
    backend_url => $backend_url,
  }

  # all coordination settings should be applied and all packages should be
  # installed before service startup
  Oslo::Coordination['cinder_config'] -> Anchor['cinder::service::begin']
}
