#
# == Define: cinder::backend::dellemc_powermax
#
# Setup Cinder to use the Dell EMC PowerMax Driver
# Compatible for multiple backends
#
# == Parameters
#
# [*san_ip*]
#   (required) IP address of PowerMax Unisphere.
#
# [*san_login*]
#   (required) PowerMax Unisphere user name.
#
# [*san_password*]
#   (required) PowerMax Unisphere user password.
#
# [*powermax_array*]
#   (required) Serial number of the PowerMax Array.
#
# [*powermax_srp*]
#   (required) Storage resource pool on array to use for provisioning.
#
# [*powermax_port_groups*]
#   (required) List of port groups.
#
# [*powermax_storage_protocol*]
#   (optional) The Storage protocol, iSCSI or FC.
#   This will determine
#   which Volume Driver will be configured; PowerMaxISCSIDriver or PowerMaxFCDriver.
#   Defaults to 'iSCSI'
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
# [*rest_api_connect_timeout*]
#   (Optional) Connection timeout value (in seconds) for rest call.
#   Defaults to $facts['os_service_default'].
#
# [*rest_api_read_timeout*]
#   (Optional) Read timeout value (in seconds) for rest call.
#   Defaults to $facts['os_service_default'].
#
# [*manage_volume_type*]
#   (Optional) Whether or not manage Cinder Volume type.
#   If set to true, a Cinder Volume type will be created
#   with volume_backend_name=$volume_backend_name key/value.
#   Defaults to false.
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend stanza
#   Defaults to: {}
#   Example :
#     { 'dellemc_powermax_backend/param1' => { 'value' => value1 } }#
#
define cinder::backend::dellemc_powermax (
  $san_ip,
  $san_login,
  $san_password,
  $powermax_array,
  $powermax_srp,
  $powermax_port_groups,
  Enum['iSCSI', 'FC'] $powermax_storage_protocol = 'iSCSI',
  $volume_backend_name                           = $name,
  $backend_availability_zone                     = $facts['os_service_default'],
  $image_volume_cache_enabled                    = $facts['os_service_default'],
  $image_volume_cache_max_size_gb                = $facts['os_service_default'],
  $image_volume_cache_max_count                  = $facts['os_service_default'],
  $reserved_percentage                           = $facts['os_service_default'],
  $max_over_subscription_ratio                   = $facts['os_service_default'],
  $rest_api_connect_timeout                      = $facts['os_service_default'],
  $rest_api_read_timeout                         = $facts['os_service_default'],
  Hash $extra_options                            = {},
  Boolean $manage_volume_type                    = false,
) {

  include cinder::deps
  include cinder::params

  $volume_driver = $powermax_storage_protocol ? {
    'FC'    => 'cinder.volume.drivers.dell_emc.powermax.fc.PowerMaxFCDriver',
    default => 'cinder.volume.drivers.dell_emc.powermax.iscsi.PowerMaxISCSIDriver',
  }

  $_powermax_port_groups = join(any2array($powermax_port_groups), ',')
  $powermax_port_groups_real = $_powermax_port_groups ? {
    /^\[.*\]$/ => $_powermax_port_groups,
    default    => "[${_powermax_port_groups}]"
  }

  cinder_config {
    "${name}/volume_backend_name":            value => $volume_backend_name;
    "${name}/backend_availability_zone":      value => $backend_availability_zone;
    "${name}/image_volume_cache_enabled":     value => $image_volume_cache_enabled;
    "${name}/image_volume_cache_max_size_gb": value => $image_volume_cache_max_size_gb;
    "${name}/image_volume_cache_max_count":   value => $image_volume_cache_max_count;
    "${name}/reserved_percentage":            value => $reserved_percentage;
    "${name}/max_over_subscription_ratio":    value => $max_over_subscription_ratio;
    "${name}/volume_driver":                  value => $volume_driver;
    "${name}/san_ip":                         value => $san_ip;
    "${name}/san_login":                      value => $san_login;
    "${name}/san_password":                   value => $san_password, secret => true;
    "${name}/powermax_array":                 value => $powermax_array;
    "${name}/powermax_srp":                   value => $powermax_srp;
    "${name}/powermax_port_groups":           value => $powermax_port_groups_real;
    "${name}/rest_api_connect_timeout":       value => $rest_api_connect_timeout;
    "${name}/rest_api_read_timeout":          value => $rest_api_read_timeout;
  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => {'volume_backend_name' => $volume_backend_name},
    }
  }

  ensure_packages( 'pywbem', {
    ensure => present,
    name   => $::cinder::params::pywbem_package_name,
    tag    => 'cinder-support-package'})

  create_resources('cinder_config', $extra_options)

}
