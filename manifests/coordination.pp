# == Class: cinder::coordination
#
# Setup and configure Cinder coordination settings.
#
# === Parameters
#
# [*backend_url*]
#   (Optional) Coordination backend URL.
#   Defaults to $::os_service_default
#
class cinder::coordination (
  $backend_url = $::os_service_default,
) {

  include ::cinder::deps

  cinder_config {
    'coordination/backend_url': value => $backend_url;
  }
}
