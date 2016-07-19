# == Class: cinder::volume::pure
#
# Configures Cinder volume PureStorage driver.
# Parameters are particular to each volume driver.
#
# === Parameters
#
# [*san_ip*]
#   (required) IP address of PureStorage management VIP.
#
# [*pure_api_token*]
#   (required) API token for management of PureStorage array.
#
# [*volume_backend_name*]
#   (optional) Allows for the volume_backend_name to be separate of $name.
#   Defaults to: $name
#
# [*pure_storage_protocol*]
#   (optional) Must be either 'iSCSI' or 'FC'. This will determine
#   which Volume Driver will be configured; PureISCSIDriver or PureFCDriver.
#   Defaults to 'iSCSI'
#
# [*use_multipath_for_image_xfer*]
#   (optional) .
#   Defaults to True
#
# [*use_chap_auth*]
#   (optional) Only affects the PureISCSIDriver.
#   Defaults to False
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend stanza.
#   Defaults to: {}
#   Example :
#     { 'pure_backend/param1' => { 'value' => value1 } }
#
class cinder::volume::pure(
  $san_ip,
  $pure_api_token,
  $use_chap_auth                = false,
  $volume_backend_name          = '',
  $use_multipath_for_image_xfer = true,
  $pure_storage_protocol        = 'iSCSI',
  $extra_options                = {},
) {

  include ::cinder::deps

  warning('Usage of cinder::volume::pure is deprecated, please use
cinder::backend::pure instead.')

  cinder::backend::pure { 'DEFAULT':
    san_ip                       => $san_ip,
    pure_api_token               => $pure_api_token,
    pure_storage_protocol        => $pure_storage_protocol,
    use_chap_auth                => $use_chap_auth,
    use_multipath_for_image_xfer => $use_multipath_for_image_xfer,
    volume_backend_name          => $volume_backend_name,
    extra_options                => $extra_options,
  }
}
