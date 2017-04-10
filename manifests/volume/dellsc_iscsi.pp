# == define: cinder::volume::dellsc_iscsi
#
# Configure the Dell Storage Center ISCSI driver for cinder.
#
# === Parameters
#
# [*san_ip*]
#   (required) IP address of Enterprise Manager.
#
# [*san_login*]
#   (required) Enterprise Manager user name.
#
# [*san_password*]
#   (required) Enterprise Manager user password.
#
# [*iscsi_ip_address*]
#   (required) The Storage Center iSCSI IP address.
#
# [*dell_sc_ssn*]
#   (required) The Storage Center serial number to use.
#
# [*dell_sc_api_port*]
#   (optional) The Enterprise Manager API port.
#   Defaults to $::os_service_default
#
# [*dell_sc_server_folder*]
#   (optional) Name of the server folder to use on the Storage Center.
#   Defaults to 'srv'
#
# [*dell_sc_verify_cert*]
#   (optional) Enable HTTPS SC certificate verification
#   Defaults to $:os_service_default
#
# [*dell_sc_volume_folder*]
#   (optional) Name of the volume folder to use on the Storage Center.
#   Defaults to 'vol'
#
# [*iscsi_port*]
#   (optional) The Storage Center iSCSI IP port.
#   Defaults to $::os_service_default
#
# [*excluded_domain_ip*]
#   (optional) Domain IP to be excluded from iSCSI returns of Storage Center.
#   Defaults to $::os_service_default
#
# [*secondary_san_ip*]
#   (optional) IP address of secondary DSM controller.
#   Defaults to $::os_service_default
#
# [*secondary_san_login*]
#   (optional) Secondary DSM user name.
#   Defaults to $::os_service_default
#
# [*secondary_san_password*]
#   (optional) Secondary DSM user password.
#   Defaults to $::os_service_default
#
# [*secondary_sc_api_port*]
#   (optional) Secondary Dell API port.
#   Defaults to os_service_default
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend stanza.
#   Defaults to: {}
#   Example:
#     { 'dellsc_iscsi_backend/param1' => { 'value' => value1 } }
#
class cinder::volume::dellsc_iscsi (
  $san_ip,
  $san_login,
  $san_password,
  $iscsi_ip_address,
  $dell_sc_ssn,
  $dell_sc_api_port       = $::os_service_default,
  $dell_sc_server_folder  = 'srv',
  $dell_sc_verify_cert    = $::os_service_default,
  $dell_sc_volume_folder  = 'vol',
  $iscsi_port             = $::os_service_default,
  $excluded_domain_ip     = $::os_service_default,
  $secondary_san_ip       = $::os_service_default,
  $secondary_san_login    = $::os_service_default,
  $secondary_san_password = $::os_service_default,
  $secondary_sc_api_port  = $::os_service_default,
  $extra_options          = {},
) {

  include ::cinder::deps

  warning('Usage of cinder::volume::dellsc_iscsi is deprecated, please use
cinder::backend::dellsc_iscsi instead.')

  cinder::backend::dellsc_iscsi { 'DEFAULT':
    san_ip                 => $san_ip,
    san_login              => $san_login,
    san_password           => $san_password,
    iscsi_ip_address       => $iscsi_ip_address,
    dell_sc_ssn            => $dell_sc_ssn,
    dell_sc_api_port       => $dell_sc_api_port,
    dell_sc_server_folder  => $dell_sc_server_folder,
    dell_sc_verify_cert    => $dell_sc_verify_cert,
    dell_sc_volume_folder  => $dell_sc_volume_folder,
    iscsi_port             => $iscsi_port,
    excluded_domain_ip     => $excluded_domain_ip,
    secondary_san_ip       => $secondary_san_ip,
    secondary_san_login    => $secondary_san_login,
    secondary_san_password => $secondary_san_password,
    secondary_sc_api_port  => $secondary_sc_api_port,
    extra_options          => $extra_options,
  }
}
