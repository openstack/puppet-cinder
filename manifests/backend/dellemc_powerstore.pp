# == define: cinder::backend::dellemc_powerstore
#
# Configure the Dell EMC PowerStore Driver for cinder.
#
# === Parameters
#
# [*san_ip*]
#   (required) PowerStore REST IP
#
# [*san_login*]
#   (required) PowerStore REST username
#
# [*san_password*]
#   (required) PowerStore REST password
#
# [*powerstore_ports*]
#   (optional) PowerStore allowed ports
#
# [*storage_protocol*]
#   (optional) The Storage protocol, iSCSI or FC.
#   Defaults to 'iSCSI'
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
# [*max_over_subscription_ratio*]
#   (Optional) Representation of the over subscription ratio when thin
#   provisionig is involved.
#   Defaults to $facts['os_service_default'].
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
#   Example:
#     { 'dellemc_powerstore_backend/param1' => { 'value' => value1 } }
#
define cinder::backend::dellemc_powerstore (
  $san_ip,
  $san_login,
  $san_password,
  $powerstore_ports                     = $facts['os_service_default'],
  Enum['iSCSI', 'FC'] $storage_protocol = 'iSCSI',
  $volume_backend_name                  = $name,
  $backend_availability_zone            = $facts['os_service_default'],
  $image_volume_cache_enabled           = $facts['os_service_default'],
  $image_volume_cache_max_size_gb       = $facts['os_service_default'],
  $image_volume_cache_max_count         = $facts['os_service_default'],
  $max_over_subscription_ratio          = $facts['os_service_default'],
  Boolean $manage_volume_type           = false,
  Hash $extra_options                   = {},
) {
  include cinder::deps

  $driver = 'dell_emc.powerstore.driver.PowerStoreDriver'

  cinder_config {
    "${name}/volume_backend_name":            value => $volume_backend_name;
    "${name}/backend_availability_zone":      value => $backend_availability_zone;
    "${name}/image_volume_cache_enabled":     value => $image_volume_cache_enabled;
    "${name}/image_volume_cache_max_size_gb": value => $image_volume_cache_max_size_gb;
    "${name}/image_volume_cache_max_count":   value => $image_volume_cache_max_count;
    "${name}/max_over_subscription_ratio":    value => $max_over_subscription_ratio;
    "${name}/volume_driver":                  value => "cinder.volume.drivers.${driver}";
    "${name}/san_ip":                         value => $san_ip;
    "${name}/san_login":                      value => $san_login;
    "${name}/san_password":                   value => $san_password, secret => true;
    "${name}/powerstore_ports":               value => $powerstore_ports;
    "${name}/storage_protocol":               value => $storage_protocol;
  }

  cinder_config {
    "${name}/powerstore_appliances": ensure => absent;
  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => { 'volume_backend_name' => $volume_backend_name },
    }
  }

  create_resources('cinder_config', $extra_options)
}
