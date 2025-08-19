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
#   Defaults to $facts['os_service_default'].
#
# [*reserved_percentage*]
#   (Optional) The percentage of backend capacity is reserved.
#   Defaults to $facts['os_service_default'].
#
# [*max_over_subscription_ratio*]
#   (Optional) Representation of the over subscription ratio when thin
#   provisionig is involved.
#   Defaults to $facts['os_service_default'].
#
# [*pure_storage_protocol*]
#   (optional) Must be either 'iSCSI', 'FC' or 'NVMe'. This will determine
#   which Volume Driver will be configured; PureISCSIDriver, PureFCDriver
#   or PureNVMEDriver.
#   Defaults to 'iSCSI'
#
# [*use_chap_auth*]
#   (optional) Use authentication for iSCSI. Only affects the PureISCSIDriver.
#   Defaults to $facts['os_service_default']
#
# [*use_multipath_for_image_xfer*]
#   (optional) Use multipath when attaching the volume for image transfer.
#   Defaults to True
#
# [*image_volume_cache_enabled*]
#   (Optional) Enable Cinder's image cache function for this backend.
#   Defaults to True
#
# [*image_volume_cache_max_size_gb*]
#   (Optional) Max size of the image volume cache for this backend in GB.
#   Defaults to $facts['os_service_default'],
#
# [*image_volume_cache_max_count*]
#   (Optional) Max number of entries allowed in the image volume cache.
#   Defaults to $facts['os_service_default'],
#
# [*pure_host_personality*]
#   (Optional) Determines how the Purity system tunes the protocol used between
#   the array and the initiator.
#   Defaults to $facts['os_service_default']
#
# [*pure_eradicate_on_delete*]
#   (Optional) Determines how the Purity system treats deleted volumes.
#   Whether to immediately eradicate on delete or leave for auto-eradication
#   in 24 hours
#   Defaults to $facts['os_service_default']
#
# [*pure_nvme_transport*]
#   (Optional) Identifies which NVMe transport layer to be used with
#   the NVMe driver.
#   Defaults to $facts['os_service_default']
#
# [*pure_nvme_cidr*]
#   (Optional) Identifies which NVMe network CIDR should be used for
#   NVMe connections to the FlashArray if the array is configured with
#   multiple NVMe VLANs.
#   Defaults to $facts['os_service_default']
#
# [*pure_nvme_cidr_list*]
#   (Optional) Identifies list of CIDR of FlashArray NVMe targets hosts
#   are allowed to connect to. It supports IPv4 and IPv6 subnets. This
#   parameter supercedes pure_nvme_cidr.
#   Defaults to $facts['os_service_default']
#
# [*pure_iscsi_cidr*]
#   (Optional) Identifies which iSCSI network CIDR should be used for
#   iscsi connections to the FlashArray if the array is configured with
#   multiple iSCSI VLANs.
#   Defaults to $facts['os_service_default']
#
# [*pure_iscsi_cidr_list*]
#   (Optional) Identifies list of CIDR of FlashArray iSCSI targets hosts are
#   allowed to connect to. It supports IPv4 and IPv6 subnets. This parameter
#   supersedes pure_iscsi_cidr.
#   Defaults to $facts['os_service_default']
#
# [*manage_volume_type*]
#   (Optional) Whether or not manage Cinder Volume type.
#   If set to true, a Cinder Volume type will be created
#   with volume_backend_name=$volume_backend_name key/value.
#   Defaults to false.
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend stanza.
#   Defaults to: {}
#   Example :
#     { 'pure_backend/param1' => { 'value' => value1 } }
#
define cinder::backend::pure (
  $san_ip,
  $pure_api_token,
  $volume_backend_name                               = $name,
  $backend_availability_zone                         = $facts['os_service_default'],
  $reserved_percentage                               = $facts['os_service_default'],
  $max_over_subscription_ratio                       = $facts['os_service_default'],
  Enum['iSCSI', 'FC', 'NVMe'] $pure_storage_protocol = 'iSCSI',
  $use_chap_auth                                     = $facts['os_service_default'],
  $use_multipath_for_image_xfer                      = true,
  $image_volume_cache_enabled                        = true,
  $image_volume_cache_max_size_gb                    = $facts['os_service_default'],
  $image_volume_cache_max_count                      = $facts['os_service_default'],
  $pure_host_personality                             = $facts['os_service_default'],
  $pure_eradicate_on_delete                          = $facts['os_service_default'],
  $pure_nvme_transport                               = $facts['os_service_default'],
  $pure_nvme_cidr                                    = $facts['os_service_default'],
  $pure_nvme_cidr_list                               = $facts['os_service_default'],
  $pure_iscsi_cidr                                   = $facts['os_service_default'],
  $pure_iscsi_cidr_list                              = $facts['os_service_default'],
  Boolean $manage_volume_type                        = false,
  Hash $extra_options                                = {},
) {
  include cinder::deps

  $volume_driver = $pure_storage_protocol ? {
    'FC'    => 'cinder.volume.drivers.pure.PureFCDriver',
    'NVMe'  => 'cinder.volume.drivers.pure.PureNVMEDriver',
    default => 'cinder.volume.drivers.pure.PureISCSIDriver',
  }

  cinder_config {
    "${name}/volume_backend_name":            value => $volume_backend_name;
    "${name}/backend_availability_zone":      value => $backend_availability_zone;
    "${name}/reserved_percentage":            value => $reserved_percentage;
    "${name}/max_over_subscription_ratio":    value => $max_over_subscription_ratio;
    "${name}/volume_driver":                  value => $volume_driver;
    "${name}/san_ip":                         value => $san_ip;
    "${name}/pure_api_token":                 value => $pure_api_token, secret => true;
    "${name}/use_chap_auth":                  value => $use_chap_auth;
    "${name}/use_multipath_for_image_xfer":   value => $use_multipath_for_image_xfer;
    "${name}/image_volume_cache_enabled":     value => $image_volume_cache_enabled;
    "${name}/image_volume_cache_max_size_gb": value => $image_volume_cache_max_size_gb;
    "${name}/image_volume_cache_max_count":   value => $image_volume_cache_max_count;
    "${name}/pure_host_personality":          value => $pure_host_personality;
    "${name}/pure_eradicate_on_delete":       value => $pure_eradicate_on_delete;
    "${name}/pure_nvme_transport":            value => $pure_nvme_transport;
    "${name}/pure_nvme_cidr":                 value => $pure_nvme_cidr;
    "${name}/pure_nvme_cidr_list":            value => join(any2array($pure_nvme_cidr_list), ',');
    "${name}/pure_iscsi_cidr":                value => $pure_iscsi_cidr;
    "${name}/pure_iscsi_cidr_list":           value => join(any2array($pure_iscsi_cidr_list), ',');
  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => { 'volume_backend_name' => $volume_backend_name },
    }
  }

  create_resources('cinder_config', $extra_options)
}
