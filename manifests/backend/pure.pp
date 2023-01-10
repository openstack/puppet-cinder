# == Class: cinder::backend::pure
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
# [*backend_availability_zone*]
#   (Optional) Availability zone for this volume backend.
#   If not set, the storage_availability_zone option value
#   is used as the default for all backends.
#   Defaults to $::os_service_default.
#
# [*pure_storage_protocol*]
#   (optional) Must be either 'iSCSI', 'FC' or 'NVMe'. This will determine
#   which Volume Driver will be configured; PureISCSIDriver, PureFCDriver
#   or PureNVMEDriver.
#   Defaults to 'iSCSI'
#
# [*use_chap_auth*]
#   (optional) Use authentication for iSCSI. Only affects the PureISCSIDriver.
#   Defaults to False
#
# [*use_multipath_for_image_xfer*]
#   (optional) Use multipath when attaching the volume for image transfer.
#   Defaults to True
#
# [*manage_volume_type*]
#   (Optional) Whether or not manage Cinder Volume type.
#   If set to true, a Cinder Volume type will be created
#   with volume_backend_name=$volume_backend_name key/value.
#   Defaults to false.
#
# [*image_volume_cache_enabled*]
#   (Optional) Enable Cinder's image cache function for the PureStorage
#   backend.
#   Defaults to True
#
# [*pure_host_personality*]
#   (Optional) Determines how the Purity system tunes the protocol used between
#   the array and the initiator.
#   Defaults to $::os_service_default
#
# [*pure_eradicate_on_delete*]
#   (Optional) Determines how the Purity system treats deleted volumes.
#   Whether to immediately eradicate on delete or leave for auto-eradication
#   in 24 hours
#   Defaults to $::os_service_default
#
# [*pure_nvme_transport*]
#   (Optional) Identifies which NVMe transport layer to be used with
#   the NVMe driver.
#   Defaults to $::os_service_default
#
# [*pure_nvme_cidr*]
#   (Optional) Identifies which NVMe network CIDR should be used for
#   NVMe connections to the FlashArray if the array is configured with
#   multiple NVMe VLANs.
#   Defaults to $::os_service_default
#
# [*pure_nvme_cidr_list*]
#   (Optional) Identifies list of CIDR of FlashArray NVMe targets hosts
#   are allowed to connect to. It supports IPv4 and IPv6 subnets. This
#   parameter supercedes pure_nvme_cidr.
#   Defaults to $::os_service_default
#
# [*pure_iscsi_cidr*]
#   (Optional) Identifies which iSCSI network CIDR should be used for
#   iscsi connections to the FlashArray if the array is configured with
#   multiple iSCSI VLANs.
#   Defaults to $::os_service_default
#
# [*pure_iscsi_cidr_list*]
#   (Optional) Identifies list of CIDR of FlashArray iSCSI targets hosts are
#   allowed to connect to. It supports IPv4 and IPv6 subnets. This parameter
#   supersedes pure_iscsi_cidr.
#   Defaults to $::os_service_default
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend stanza.
#   Defaults to: {}
#   Example :
#     { 'pure_backend/param1' => { 'value' => value1 } }
#
define cinder::backend::pure(
  $san_ip,
  $pure_api_token,
  $volume_backend_name          = $name,
  $backend_availability_zone    = $::os_service_default,
  $pure_storage_protocol        = 'iSCSI',
  $use_chap_auth                = false,
  $use_multipath_for_image_xfer = true,
  $manage_volume_type           = false,
  $image_volume_cache_enabled   = true,
  $pure_host_personality        = $::os_service_default,
  $pure_eradicate_on_delete     = $::os_service_default,
  $pure_nvme_transport          = $::os_service_default,
  $pure_nvme_cidr               = $::os_service_default,
  $pure_nvme_cidr_list          = $::os_service_default,
  $pure_iscsi_cidr              = $::os_service_default,
  $pure_iscsi_cidr_list         = $::os_service_default,
  $extra_options                = {},
) {

  include cinder::deps

  $volume_driver = $pure_storage_protocol ? {
    'FC'    => 'cinder.volume.drivers.pure.PureFCDriver',
    'iSCSI' => 'cinder.volume.drivers.pure.PureISCSIDriver',
    'NVMe'  => 'cinder.volume.drivers.pure.PureNVMEDriver',
    default => undef,
  }

  if ! $volume_driver {
    fail('Invalid pure_storage_protocol. It should be FC, iSCSI or NVMe')
  }

  cinder_config {
    "${name}/volume_backend_name":           value => $volume_backend_name;
    "${name}/backend_availability_zone":     value => $backend_availability_zone;
    "${name}/volume_driver":                 value => $volume_driver;
    "${name}/san_ip":                        value => $san_ip;
    "${name}/pure_api_token":                value => $pure_api_token, secret => true;
    "${name}/use_chap_auth":                 value => $use_chap_auth;
    "${name}/use_multipath_for_image_xfer":  value => $use_multipath_for_image_xfer;
    "${name}/image_volume_cache_enabled":    value => $image_volume_cache_enabled;
    "${name}/pure_host_personality":         value => $pure_host_personality;
    "${name}/pure_eradicate_on_delete":      value => $pure_eradicate_on_delete;
    "${name}/pure_nvme_transport":           value => $pure_nvme_transport;
    "${name}/pure_nvme_cidr":                value => $pure_nvme_cidr;
    "${name}/pure_nvme_cidr_list":           value => join(any2array($pure_nvme_cidr_list), ',');
    "${name}/pure_iscsi_cidr":               value => $pure_iscsi_cidr;
    "${name}/pure_iscsi_cidr_list":          value => join(any2array($pure_iscsi_cidr_list), ',');
  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => ["volume_backend_name=${volume_backend_name}"],
    }
  }

  create_resources('cinder_config', $extra_options)
}
