# == define: cinder::backend::dellemc_sc
#
# Configure the Dell Storage Center Driver for cinder.
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
# [*dell_sc_ssn*]
#   (required) The Storage Center serial number to use.
#
# [*target_ip_address*]
#   (optional) The IP address that the iSCSI daemon is listening on.
#   Defaults to undef. Only applicable for iSCSI driver.
#
# [*volume_backend_name*]
#   (optional) The storage backend name.
#   Defaults to the name of the backend
#
# [*backend_availability_zone*]
#   (Optional) Availability zone for this volume backend.
#   If not set, the storage_availability_zone option value
#   is used as the default for all backends.
#   Defaults to $facts['os_service_default'].
#
# [*dell_sc_api_port*]
#   (optional) The Enterprise Manager API port.
#   Defaults to $facts['os_service_default']
#
# [*dell_sc_server_folder*]
#   (optional) Name of the server folder to use on the Storage Center.
#   Defaults to 'srv'
#
# [*dell_sc_verify_cert*]
#   (optional) Enable HTTPS SC certificate verification
#   Defaults to $facts['os_service_default']
#
# [*dell_sc_volume_folder*]
#   (optional) Name of the volume folder to use on the Storage Center.
#   Defaults to 'vol'
#
# [*target_port*]
#   (optional) The ISCSI IP Port of the Storage Center.
#   Defaults to $facts['os_service_default']
#
# [*excluded_domain_ips*]
#   (optional)Comma separated list of domain IPs to be excluded from
#   iSCSI returns of Storage Center.
#   Defaults to $facts['os_service_default']
#
# [*secondary_san_ip*]
#   (optional) IP address of secondary DSM controller.
#   Defaults to $facts['os_service_default']
#
# [*secondary_san_login*]
#   (optional) Secondary DSM user name.
#   Defaults to $facts['os_service_default']
#
# [*secondary_san_password*]
#   (optional) Secondary DSM user password.
#   Defaults to $facts['os_service_default']
#
# [*secondary_sc_api_port*]
#   (optional) Secondary Dell API port.
#   Defaults to $facts['os_service_default']
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend stanza.
#   Defaults to: {}
#   Example:
#     { 'dellemc_sc_backend/param1' => { 'value' => value1 } }
#
# [*manage_volume_type*]
#   (Optional) Whether or not manage Cinder Volume type.
#   If set to true, a Cinder Volume type will be created
#   with volume_backend_name=$volume_backend_name key/value.
#   Defaults to false.
#
# [*use_multipath_for_image_xfer*]
#   (Optional) Enables multipath configuration.
#   Defaults to true.
#
# [*sc_storage_protocol*]
#   (optional) The Storage protocol, iSCSI or FC.
#   This will determine
#   which Volume Driver will be configured; SCISCSIDriver or SCFCDriver.
#   Defaults to 'iSCSI'
#
define cinder::backend::dellemc_sc (
  $san_ip,
  $san_login,
  $san_password,
  $dell_sc_ssn,
  $target_ip_address                       = undef,
  $volume_backend_name                     = $name,
  $backend_availability_zone               = $facts['os_service_default'],
  $dell_sc_api_port                        = $facts['os_service_default'],
  $dell_sc_server_folder                   = 'srv',
  $dell_sc_verify_cert                     = $facts['os_service_default'],
  $dell_sc_volume_folder                   = 'vol',
  $target_port                             = $facts['os_service_default'],
  $excluded_domain_ips                     = $facts['os_service_default'],
  $secondary_san_ip                        = $facts['os_service_default'],
  $secondary_san_login                     = $facts['os_service_default'],
  $secondary_san_password                  = $facts['os_service_default'],
  $secondary_sc_api_port                   = $facts['os_service_default'],
  Boolean $manage_volume_type              = false,
  $use_multipath_for_image_xfer            = true,
  Enum['iSCSI', 'FC'] $sc_storage_protocol = 'iSCSI',
  Hash $extra_options                      = {},
) {

  include cinder::deps

  $volume_driver = $sc_storage_protocol ? {
    'FC'    => 'cinder.volume.drivers.dell_emc.sc.storagecenter_fc.SCFCDriver',
    default => 'cinder.volume.drivers.dell_emc.sc.storagecenter_iscsi.SCISCSIDriver',
  }

  cinder_config {
    "${name}/volume_backend_name":          value => $volume_backend_name;
    "${name}/backend_availability_zone":    value => $backend_availability_zone;
    "${name}/volume_driver":                value => $volume_driver;
    "${name}/san_ip":                       value => $san_ip;
    "${name}/san_login":                    value => $san_login;
    "${name}/san_password":                 value => $san_password, secret => true;
    "${name}/target_ip_address":            value => $target_ip_address;
    "${name}/dell_sc_ssn":                  value => $dell_sc_ssn;
    "${name}/dell_sc_api_port":             value => $dell_sc_api_port;
    "${name}/dell_sc_server_folder":        value => $dell_sc_server_folder;
    "${name}/dell_sc_verify_cert":          value => $dell_sc_verify_cert;
    "${name}/dell_sc_volume_folder":        value => $dell_sc_volume_folder;
    "${name}/target_port":                  value => $target_port;
    "${name}/excluded_domain_ips":          value => $excluded_domain_ips;
    "${name}/secondary_san_ip":             value => $secondary_san_ip;
    "${name}/secondary_san_login":          value => $secondary_san_login;
    "${name}/secondary_san_password":       value => $secondary_san_password, secret => true;
    "${name}/secondary_sc_api_port":        value => $secondary_sc_api_port;
    "${name}/use_multipath_for_image_xfer": value => $use_multipath_for_image_xfer;
  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => ["volume_backend_name=${volume_backend_name}"],
    }
  }

  create_resources('cinder_config', $extra_options)

}
