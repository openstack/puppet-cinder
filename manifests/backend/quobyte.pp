#
# == Class: cinder::backend::quobyte
#
# Configures Cinder to use Quobyte USP as a volume driver
#
# === Parameters
#
# [*quobyte_volume_url*]
#   (required) The URL of the Quobyte volume to use.
#   Not an array as a Quobyte driver instance supports exactly one volume
#   at a time - but you can load the driver more than once.
#   Example: quobyte://quobyte.cluster.example.com/volume-name
#
# [*quobyte_client_cfg*]
#   (optional) Path to a Quobyte client configuration file.
#   This is needed if client certificate authentication is enabled on the
#   Quobyte cluster. The config file includes the certificate and key.
#
# [*quobyte_qcow2_volumes*]
#   (optional) Boolean if volumes should be created as qcow2 volumes.
#   Defaults to True. qcow2 volumes allow snapshots, at the cost of a small
#   performance penalty. If False, raw volumes will be used.
#
# [*quobyte_sparsed_volumes*]
#   (optional) Boolean if raw volumes should be created as sparse files.
#   Defaults to True. Non-sparse volumes may have a very small performance
#   benefit, but take a long time to create.
#
# [*quobyte_mount_point_base*]
#   (optional) Path where the driver should create mountpoints.
#   Defaults to a subdirectory "mnt" under the Cinder state directory.
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
# [*manage_volume_type*]
#   (Optional) Whether or not manage Cinder Volume type.
#   If set to true, a Cinder Volume type will be created
#   with volume_backend_name=$volume_backend_name key/value.
#   Defaults to false.
#
# === Examples
#
# cinder::backend::quobyte { 'quobyte1':
#   quobyte_volume_url => 'quobyte://quobyte.cluster.example.com/volume-name',
# }
#
define cinder::backend::quobyte (
  $quobyte_volume_url,
  $quobyte_client_cfg             = undef,
  $quobyte_qcow2_volumes          = undef,
  $quobyte_sparsed_volumes        = undef,
  $quobyte_mount_point_base       = undef,
  $volume_backend_name            = $name,
  $backend_availability_zone      = $facts['os_service_default'],
  $image_volume_cache_enabled     = $facts['os_service_default'],
  $image_volume_cache_max_size_gb = $facts['os_service_default'],
  $image_volume_cache_max_count   = $facts['os_service_default'],
  Boolean $manage_volume_type     = false,
) {

  include cinder::deps

  cinder_config {
    "${name}/volume_backend_name":            value => $volume_backend_name;
    "${name}/backend_availability_zone":      value => $backend_availability_zone;
    "${name}/image_volume_cache_enabled":     value => $image_volume_cache_enabled;
    "${name}/image_volume_cache_max_size_gb": value => $image_volume_cache_max_size_gb;
    "${name}/image_volume_cache_max_count":   value => $image_volume_cache_max_count;
    "${name}/volume_driver":                  value => 'cinder.volume.drivers.quobyte.QuobyteDriver';
    "${name}/quobyte_volume_url":             value => $quobyte_volume_url;
    "${name}/quobyte_client_cfg":             value => $quobyte_client_cfg;
    "${name}/quobyte_qcow2_volumes":          value => $quobyte_qcow2_volumes;
    "${name}/quobyte_sparsed_volumes":        value => $quobyte_sparsed_volumes;
    "${name}/quobyte_mount_point_base":       value => $quobyte_mount_point_base;
  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => ["volume_backend_name=${volume_backend_name}"],
    }
  }

}
