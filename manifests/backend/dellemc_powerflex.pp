# == define: cinder::backend::dellemc_powerflex
#
# Configures Cinder to use the Dell EMC PowerFlex Block Storage driver
# Compatible for multiple backends
#
# === Parameters
#
# [*san_login*]
#   (required) Administrative user account name used to access the storage
#   system or proxy server.
#
# [*san_password*]
#   (required) Password for the administrative user account specified in the
#   san_login option.
#
# [*san_ip*]
#   (required) The hostname (or IP address) for the storage system or proxy
#   server.
#
# [*powerflex_storage_pools*]
#   (String) (required)  Storage Pools. Comma separated list of storage pools used to provide volumes.
#   Each pool should be specified as a protection_domain_name:storage_pool_name value
#
# [*volume_backend_name*]
#   (optional) The name of the cinder::backend::dellemc_powerflex resource
#   Defaults to $name.
#
# [*backend_availability_zone*]
#   (optional) Availability zone for this volume backend.
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
# [*powerflex_allow_migration_during_rebuild*]
#   (optional) (Boolean) Allow volume migration during rebuild.
#   Defaults to $facts['os_service_default']
#
# [*powerflex_allow_non_padded_volumes*]
#   (optional) (Boolean) Allow volumes to be created in Storage Pools
#   when zero padding is disabled.
#   Defaults to $facts['os_service_default']
#
# [*powerflex_max_over_subscription_ratio*]
#   (optional) (Floating point) max_over_subscription_ratio setting for the driver.
#   Maximum value allowed is 10.0.
#   Defaults to $facts['os_service_default']
#
# [*powerflex_rest_server_port*]
#   (optional) (String) The TCP port to use for communication with the storage
#   system or proxy.
#   Defaults to $facts['os_service_default']
#
# [*powerflex_round_volume_capacity*]
#  (optional) (Boolean) Round volume sizes up to 8GB boundaries. PowerFlex/ScaleIO
#  requires volumes to be sized in multiples of 8GB. If set to False,
#  volume creation will fail for volumes not sized properly
#  Defaults to $facts['os_service_default']
#
# [*powerflex_server_api_version*]
#   (optional) (String) PowerFlex/ScaleIO API version. This value should be left as the
#   default value unless otherwise instructed by technical support.
#
# [*powerflex_unmap_volume_before_deletion*]
#   (optional) (Boolean) Unmap volumes before deletion.
#   Defaults to $facts['os_service_default']
#
# [*rest_api_connect_timeout*]
#   (Optional) Connection timeout value (in seconds) for rest call.
#   Defaults to $facts['os_service_default'].
#
# [*rest_api_read_timeout*]
#   (Optional) Read timeout value (in seconds) for rest call.
#   Defaults to $facts['os_service_default'].
#
# [*san_thin_provision*]
#   (optional) (Boolean) Whether to use thin provisioning or not.
#   Defaults to $facts['os_service_default']
#
# [*driver_ssl_cert_verify*]
#   (optional) Verify the server certificate
#   Defaults to $facts['os_service_default']
#
# [*driver_ssl_cert_path*]
#   (optional) Server certificate path.
#   Defaults to $facts['os_service_default']
#
# [*manage_volume_type*]
#   (optional) Whether or not manage Cinder Volume type.
#   If set to true, a Cinder Volume type will be created
#   with volume_backend_name=$volume_backend_name key/value.
#   Defaults to false.
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend stanza
#   Defaults to: {}
#   Example :
#     { 'powerflex_backend/param1' => { 'value' => value1 } }
#
# === Examples
#
#  cinder::backend::dellemc_powerflex { 'myBackend':
#    san_login               => 'admin',
#    san_password            => 'password',
#    san_ip                  => 'powerflex_.mycorp.com',
#    powerflex_storage_pools => 'domain1:pool1',
#  }
#
define cinder::backend::dellemc_powerflex(
  $san_login,
  $san_password,
  $san_ip,
  $powerflex_storage_pools,
  $volume_backend_name                      = $name,
  $backend_availability_zone                = $facts['os_service_default'],
  $image_volume_cache_enabled               = $facts['os_service_default'],
  $image_volume_cache_max_size_gb           = $facts['os_service_default'],
  $image_volume_cache_max_count             = $facts['os_service_default'],
  $powerflex_allow_migration_during_rebuild = $facts['os_service_default'],
  $powerflex_allow_non_padded_volumes       = $facts['os_service_default'],
  $powerflex_max_over_subscription_ratio    = $facts['os_service_default'],
  $powerflex_rest_server_port               = $facts['os_service_default'],
  $powerflex_round_volume_capacity          = $facts['os_service_default'],
  $powerflex_server_api_version             = $facts['os_service_default'],
  $powerflex_unmap_volume_before_deletion   = $facts['os_service_default'],
  $rest_api_connect_timeout                 = $facts['os_service_default'],
  $rest_api_read_timeout                    = $facts['os_service_default'],
  $san_thin_provision                       = $facts['os_service_default'],
  $driver_ssl_cert_verify                   = $facts['os_service_default'],
  $driver_ssl_cert_path                     = $facts['os_service_default'],
  Boolean $manage_volume_type               = false,
  Hash $extra_options                       = {},
) {

  include cinder::deps

  cinder_config {
    "${name}/volume_driver":                            value => 'cinder.volume.drivers.dell_emc.powerflex.driver.PowerFlexDriver';
    "${name}/san_login":                                value => $san_login;
    "${name}/san_password":                             value => $san_password, secret => true;
    "${name}/san_ip":                                   value => $san_ip;
    "${name}/powerflex_storage_pools":                  value => $powerflex_storage_pools;
    "${name}/volume_backend_name":                      value => $volume_backend_name;
    "${name}/backend_availability_zone":                value => $backend_availability_zone;
    "${name}/image_volume_cache_enabled":               value => $image_volume_cache_enabled;
    "${name}/image_volume_cache_max_size_gb":           value => $image_volume_cache_max_size_gb;
    "${name}/image_volume_cache_max_count":             value => $image_volume_cache_max_count;
    "${name}/powerflex_allow_migration_during_rebuild": value => $powerflex_allow_migration_during_rebuild;
    "${name}/powerflex_allow_non_padded_volumes":       value => $powerflex_allow_non_padded_volumes;
    "${name}/powerflex_max_over_subscription_ratio":    value => $powerflex_max_over_subscription_ratio;
    "${name}/powerflex_rest_server_port":               value => $powerflex_rest_server_port;
    "${name}/powerflex_round_volume_capacity":          value => $powerflex_round_volume_capacity;
    "${name}/powerflex_server_api_version":             value => $powerflex_server_api_version;
    "${name}/powerflex_unmap_volume_before_deletion":   value => $powerflex_unmap_volume_before_deletion;
    "${name}/rest_api_connect_timeout":                 value => $rest_api_connect_timeout;
    "${name}/rest_api_read_timeout":                    value => $rest_api_read_timeout;
    "${name}/san_thin_provision":                       value => $san_thin_provision;
    "${name}/driver_ssl_cert_verify":                   value => $driver_ssl_cert_verify;
    "${name}/driver_ssl_cert_path":                     value => $driver_ssl_cert_path;
  }
  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => {'volume_backend_name' => $volume_backend_name},
    }
  }

  create_resources('cinder_config', $extra_options)

}
