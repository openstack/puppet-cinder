# == Class: cinder::backend::nexenta
#
# Setups Cinder with Nexenta volume driver.
#
# === Parameters
#
# [*nexenta_user*]
#   (required) User name to connect to Nexenta SA.
#
# [*nexenta_password*]
#   (required) Password to connect to Nexenta SA.
#
# [*nexenta_host*]
#   (required) IP address of Nexenta SA.
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
# [*nexenta_volume*]
#   (optional) Pool on SA that will hold all volumes.
#   Defaults to 'cinder'.
#
# [*nexenta_target_prefix*]
#   (optional) IQN prefix for iSCSI targets.
#   Defaults to 'iqn:'.
#
# [*nexenta_target_group_prefix*]
#   (optional) Prefix for iSCSI target groups on SA.
#   Defaults to 'cinder/'.
#
# [*nexenta_blocksize*]
#   (optional) Block size for volumes.
#   Defaults to '8192'.
#
# [*nexenta_sparse*]
#   (optional) Flag to create sparse volumes.
#   Defaults to true.
#
# [*nexenta_rest_port*]
#   (optional) HTTP port for REST API.
#   Defaults to '8457'.
#
# [*volume_driver*]
#   (required) Nexenta driver to use.
#   Defaults to: 'cinder.volume.drivers.nexenta.iscsi.NexentaISCSIDriver'.
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
#     { 'nexenta_backend/param1' => { 'value' => value1 } }
#
define cinder::backend::nexenta (
  $nexenta_user,
  $nexenta_password,
  $nexenta_host,
  $volume_backend_name            = $name,
  $backend_availability_zone      = $facts['os_service_default'],
  $image_volume_cache_enabled     = $facts['os_service_default'],
  $image_volume_cache_max_size_gb = $facts['os_service_default'],
  $image_volume_cache_max_count   = $facts['os_service_default'],
  $reserved_percentage            = $facts['os_service_default'],
  $nexenta_volume                 = 'cinder',
  $nexenta_target_prefix          = 'iqn:',
  $nexenta_target_group_prefix    = 'cinder/',
  $nexenta_blocksize              = '8192',
  $nexenta_sparse                 = true,
  $nexenta_rest_port              = '8457',
  $volume_driver                  = 'cinder.volume.drivers.nexenta.iscsi.NexentaISCSIDriver',
  Boolean $manage_volume_type     = false,
  Hash $extra_options             = {},
) {

  include cinder::deps

  cinder_config {
    "${name}/volume_backend_name":            value => $volume_backend_name;
    "${name}/backend_availability_zone":      value => $backend_availability_zone;
    "${name}/image_volume_cache_enabled":     value => $image_volume_cache_enabled;
    "${name}/image_volume_cache_max_size_gb": value => $image_volume_cache_max_size_gb;
    "${name}/image_volume_cache_max_count":   value => $image_volume_cache_max_count;
    "${name}/reserved_percentage":            value => $reserved_percentage;
    "${name}/nexenta_user":                   value => $nexenta_user;
    "${name}/nexenta_password":               value => $nexenta_password, secret => true;
    "${name}/nexenta_host":                   value => $nexenta_host;
    "${name}/nexenta_volume":                 value => $nexenta_volume;
    "${name}/nexenta_target_prefix":          value => $nexenta_target_prefix;
    "${name}/nexenta_target_group_prefix":    value => $nexenta_target_group_prefix;
    "${name}/nexenta_blocksize":              value => $nexenta_blocksize;
    "${name}/nexenta_sparse":                 value => $nexenta_sparse;
    "${name}/nexenta_rest_port":              value => $nexenta_rest_port;
    "${name}/volume_driver":                  value => $volume_driver;
  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => ["volume_backend_name=${volume_backend_name}"],
    }
  }

  create_resources('cinder_config', $extra_options)

}
