#
# Define: cinder::backend::nvmeof
#
# === Parameters:
#
# [*target_ip_address*]
#   (Required) The IP address of NVMe target.
#
# [*target_helper*]
#   (Required) Target user-land tool to use.
#
# [*target_protocol*]
#   (Required) Target protocol to use.
#
# [*target_port*]
#   (Optional) Port that NVMe target is listening on.
#   Defaults to 4420, the NVMe standard I/O port.
#
# [*target_prefix*]
#   (Optional) Prefix for LVM volumes.
#   Defaults to $facts['os_service_default'].
#
# [*nvmet_port_id*]
#   (Optional) Port id of the NVMe target.
#   Defaults to $facts['os_service_default'].
#
# [*nvmet_ns_id*]
#   (Optional) The namespace id associated with the subsystem.
#   Defaults to $facts['os_service_default'].
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
# [*image_volume_cache_enabled*]
#   (Optional) Enable Cinder's image cache function for this backend.
#   Defaults to $facts['os_service_default'],
#
# [*image_volume_cache_max_size_gb*]
#   (Optional) Max size of the image volume cache for this backend in GB.
#   Defaults to $facts['os_service_default'],
#
# [*image_volume_cache_max_count*]
#   (Optional) Max number of entries allowed in the image volume cache.
#   Defaults to $facts['os_service_default'],
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
# [*volume_driver*]
#   (Optional) Driver to use for volume creation
#   Defaults to 'cinder.volume.drivers.lvm.LVMVolumeDriver'.
#
# [*volume_group*]
#   (Optional) Name for the VG that will contain exported volumes
#   Defaults to $facts['os_service_default']
#
# [*nvmeof_conn_info_version*]
#   (Optional) NVMe-oF Connection Information version
#   Defaults to $facts['os_service_default']
#
# [*lvm_share_target*]
#   (Optional) Use shared targets or per-volume targets
#   Defaults to $facts['os_service_default']
#
# [*target_secondary_ip_addresses*]
#   (Optional) Additional, list or comma separated string, ip addresses to map the NVMe-oF volume
#   Defaults to $facts['os_service_default']
#
# [*lvm_type*]
#   (Optional) Type of LVM volumes to deploy
#   Defaults to $facts['os_service_default'].
#
define cinder::backend::nvmeof (
  $target_ip_address,
  $target_helper,
  $target_protocol,
  $target_port                    = '4420',
  $target_prefix                  = $facts['os_service_default'],
  $nvmet_port_id                  = $facts['os_service_default'],
  $nvmet_ns_id                    = $facts['os_service_default'],
  $volume_backend_name            = $name,
  $backend_availability_zone      = $facts['os_service_default'],
  $image_volume_cache_enabled     = $facts['os_service_default'],
  $image_volume_cache_max_size_gb = $facts['os_service_default'],
  $image_volume_cache_max_count   = $facts['os_service_default'],
  $reserved_percentage            = $facts['os_service_default'],
  $max_over_subscription_ratio    = $facts['os_service_default'],
  $volume_driver                  = 'cinder.volume.drivers.lvm.LVMVolumeDriver',
  $volume_group                   = $facts['os_service_default'],
  $nvmeof_conn_info_version       = $facts['os_service_default'],
  $lvm_share_target               = $facts['os_service_default'],
  $target_secondary_ip_addresses  = $facts['os_service_default'],
  $lvm_type                       = $facts['os_service_default'],
) {

  include cinder::deps
  include cinder::params

  cinder_config {
    "${name}/target_ip_address":              value => $target_ip_address;
    "${name}/target_port":                    value => $target_port;
    "${name}/target_helper":                  value => $target_helper;
    "${name}/target_protocol":                value => $target_protocol;
    "${name}/target_prefix":                  value => $target_prefix;
    "${name}/nvmet_port_id":                  value => $nvmet_port_id;
    "${name}/nvmet_ns_id":                    value => $nvmet_ns_id;
    "${name}/volume_backend_name":            value => $volume_backend_name;
    "${name}/backend_availability_zone":      value => $backend_availability_zone;
    "${name}/image_volume_cache_enabled":     value => $image_volume_cache_enabled;
    "${name}/image_volume_cache_max_size_gb": value => $image_volume_cache_max_size_gb;
    "${name}/image_volume_cache_max_count":   value => $image_volume_cache_max_count;
    "${name}/reserved_percentage":            value => $reserved_percentage;
    "${name}/max_over_subscription_ratio":    value => $max_over_subscription_ratio;
    "${name}/volume_driver":                  value => $volume_driver;
    "${name}/volume_group":                   value => $volume_group;
    "${name}/nvmeof_conn_info_version":       value => $nvmeof_conn_info_version;
    "${name}/lvm_share_target":               value => $lvm_share_target;
    "${name}/target_secondary_ip_addresses":  value => join(any2array($target_secondary_ip_addresses), ',');
    "${name}/lvm_type":                       value => $lvm_type;
  }

  if $::cinder::params::nvmetcli_package_name {
    stdlib::ensure_packages ( 'nvmetcli', {
      ensure => present,
      name   => $::cinder::params::nvmetcli_package_name,
      tag    => 'cinder-support-package',
    })
  } else {
    warning('The nvmetcli package is not available in this operating system.')
  }

  stdlib::ensure_packages ( 'nvme-cli', {
    ensure => present,
    name   => $::cinder::params::nvme_cli_package_name,
    tag    => 'cinder-support-package',
  })
}
