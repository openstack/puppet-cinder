# == Class: cinder::nova
#
# Setup and configure cinder.conf nova section.
#
# === Parameters
#
# [*region_name*]
#   (Optional) Name of nova region to use.
#   Defaults to $::os_service_default
#
# [*interface*]
#   (Optional) Type of the nova endpoint to use.
#   Defaults to $::os_service_default
#
# [*token_auth_url*]
#   (Optional) The authentication URL for the nova
#   connection when using the current users token.
#   Defaults to $::os_service_default
#
# [*cafile*]
#   (Optional) PEM encoded Certificate Authority to use
#   when verifying HTTPs connections.
#   Defaults to $::os_service_default
#
# [*certfile*]
#   (Optional) PEM encoded client certificate cert file.
#   Defaults to $::os_service_default
#
# [*keyfile*]
#   (Optional) PEM encoded client certificate key file.
#   Defaults to $::os_service_default
#
# [*insecure*]
#   (Optional) Verify HTTPS connections.
#   Defaults to $::os_service_default
#
# [*timeout*]
#   (Optional) Timeout value for http requests.
#   Defaults to $::os_service_default
#
# [*collect_timing*]
#   (Optional) Collect per-API call timing information.
#   Defaults to $::os_service_default
#
# [*split_loggers*]
#   (Optional) Log requests to multiple loggers.
#   Defaults to $::os_service_default
#
# [*auth_type*]
#   (Optional) Authentication type to load.
#   Defaults to $::os_service_default
#
# [*auth_section*]
#   (Optional) Config Section from which to load plugin
#   specific options.
#   Defaults to $::os_service_default
#
class cinder::nova (
  $region_name    = $::os_service_default,
  $interface      = $::os_service_default,
  $token_auth_url = $::os_service_default,
  $cafile         = $::os_service_default,
  $certfile       = $::os_service_default,
  $keyfile        = $::os_service_default,
  $insecure       = $::os_service_default,
  $timeout        = $::os_service_default,
  $collect_timing = $::os_service_default,
  $split_loggers  = $::os_service_default,
  $auth_type      = $::os_service_default,
  $auth_section   = $::os_service_default,
) {

  include ::cinder::deps

  cinder_config {
    'nova/region_name':    value => $region_name;
    'nova/interface':      value => $interface;
    'nova/token_auth_url': value => $token_auth_url;
    'nova/cafile':         value => $cafile;
    'nova/certfile':       value => $certfile;
    'nova/keyfile':        value => $keyfile;
    'nova/insecure':       value => $insecure;
    'nova/timeout':        value => $timeout;
    'nova/collect_timing': value => $collect_timing;
    'nova/split_loggers':  value => $split_loggers;
    'nova/auth_type':      value => $auth_type;
    'nova/auth_section':   value => $auth_section;
  }
}
