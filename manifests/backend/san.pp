# == Class: cinder::backend::san
#
# Configures Cinder volume SAN driver.
# Parameters are particular to each volume driver.
#
# === Parameters
#
# [*volume_driver*]
#   (required) Setup cinder-volume to use volume driver.
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
# [*san_thin_provision*]
#   (optional) Use thin provisioning for SAN volumes?
#   Defaults to $facts['os_service_default'].
#
# [*san_ip*]
#   (optional) IP address of SAN controller.
#   Defaults to $facts['os_service_default'].
#
# [*san_login*]
#   (optional) Username for SAN controller. Defaults to 'admin'.
#   Defaults to $facts['os_service_default'].
#
# [*san_password*]
#   (optional) Password for SAN controller.
#   Defaults to $facts['os_service_default'].
#
# [*san_private_key*]
#   (optional) Filename of private key to use for SSH authentication.
#   Defaults to $facts['os_service_default'].
#
# [*san_clustername*]
#   (optional) Cluster name to use for creating volumes.
#   Defaults to $facts['os_service_default'].
#
# [*san_ssh_port*]
#   (optional) SSH port to use with SAN.
#   Defaults to $facts['os_service_default'].
#
# [*san_api_port*]
#   (optional) Port to use to access the SAN API.
#   Defaults to $facts['os_service_default'].
#
# [*san_is_local*]
#   (optional) Execute commands locally instead of over SSH
#   use if the volume service is running on the SAN device.
#   Defaults to $facts['os_service_default'].
#
# [*ssh_conn_timeout*]
#   (optional) SSH connection timeout in seconds.
#   Defaults to $facts['os_service_default'].
#
# [*ssh_min_pool_conn*]
#   (optional) Minimum ssh connections in the pool.
#   Defaults to $facts['os_service_default'].
#
# [*ssh_max_pool_conn*]
#   (Optional) Maximum ssh connections in the pool.
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
#     { 'san_backend/param1' => { 'value' => value1 } }
#
define cinder::backend::san (
  $volume_driver,
  $volume_backend_name            = $name,
  $backend_availability_zone      = $facts['os_service_default'],
  $image_volume_cache_enabled     = $facts['os_service_default'],
  $image_volume_cache_max_size_gb = $facts['os_service_default'],
  $image_volume_cache_max_count   = $facts['os_service_default'],
  $san_thin_provision             = $facts['os_service_default'],
  $san_ip                         = $facts['os_service_default'],
  $san_login                      = $facts['os_service_default'],
  $san_password                   = $facts['os_service_default'],
  $san_private_key                = $facts['os_service_default'],
  $san_clustername                = $facts['os_service_default'],
  $san_ssh_port                   = $facts['os_service_default'],
  $san_api_port                   = $facts['os_service_default'],
  $san_is_local                   = $facts['os_service_default'],
  $ssh_conn_timeout               = $facts['os_service_default'],
  $ssh_min_pool_conn              = $facts['os_service_default'],
  $ssh_max_pool_conn              = $facts['os_service_default'],
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
    "${name}/volume_driver":                  value => $volume_driver;
    "${name}/san_thin_provision":             value => $san_thin_provision;
    "${name}/san_ip":                         value => $san_ip;
    "${name}/san_login":                      value => $san_login;
    "${name}/san_password":                   value => $san_password, secret => true;
    "${name}/san_private_key":                value => $san_private_key;
    "${name}/san_clustername":                value => $san_clustername;
    "${name}/san_ssh_port":                   value => $san_ssh_port;
    "${name}/san_api_port":                   value => $san_api_port;
    "${name}/san_is_local":                   value => $san_is_local;
    "${name}/ssh_conn_timeout":               value => $ssh_conn_timeout;
    "${name}/ssh_min_pool_conn":              value => $ssh_min_pool_conn;
    "${name}/ssh_max_pool_conn":              value => $ssh_max_pool_conn;
  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => {'volume_backend_name' => $volume_backend_name},
    }
  }

  create_resources('cinder_config', $extra_options)

}
