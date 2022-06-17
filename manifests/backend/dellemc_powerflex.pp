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
#   Defaults to $::os_service_default.
#
# [*powerflex_allow_migration_during_rebuild*]
#   (optional) (Boolean) Allow volume migration during rebuild.
#   Defaults to $::os_service_default
#
# [*powerflex_allow_non_padded_volumes*]
#   (optional) (Boolean) Allow volumes to be created in Storage Pools
#   when zero padding is disabled.
#   Defaults to $::os_service_default
#
# [*powerflex_max_over_subscription_ratio*]
#   (optional) (Floating point) max_over_subscription_ratio setting for the driver.
#   Maximum value allowed is 10.0.
#   Defaults to $::os_service_default
#
# [*powerflex_rest_server_port*]
#   (optional) (String) The TCP port to use for communication with the storage
#   system or proxy.
#   Defaults to $::os_service_default
#
# [*powerflex_round_volume_capacity*]
#  (optional) (Boolean) Round volume sizes up to 8GB boundaries. PowerFlex/ScaleIO
#  requires volumes to be sized in multiples of 8GB. If set to False,
#  volume creation will fail for volumes not sized properly
#  Defaults to $::os_service_default
#
# [*powerflex_server_api_version*]
#   (optional) (String) PowerFlex/ScaleIO API version. This value should be left as the
#   default value unless otherwise instructed by technical support.
#
# [*powerflex_unmap_volume_before_deletion*]
#   (optional) (Boolean) Unmap volumes before deletion.
#   Defaults to $::os_service_default
#
# [*san_thin_provision*]
#   (optional) (Boolean) Whether to use thin provisioning or not.
#   Defaults to $::os_service_default
#
# [*driver_ssl_cert_verify*]
#   (optional) Verify the server certificate
#   Defaults to $::os_service_default
#
# [*driver_ssl_cert_path*]
#   (optional) Server certificate path.
#   Defaults to $::os_service_default
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
  $backend_availability_zone                = $::os_service_default,
  $powerflex_allow_migration_during_rebuild = $::os_service_default,
  $powerflex_allow_non_padded_volumes       = $::os_service_default,
  $powerflex_max_over_subscription_ratio    = $::os_service_default,
  $powerflex_rest_server_port               = $::os_service_default,
  $powerflex_round_volume_capacity          = $::os_service_default,
  $powerflex_server_api_version             = $::os_service_default,
  $powerflex_unmap_volume_before_deletion   = $::os_service_default,
  $san_thin_provision                       = $::os_service_default,
  $driver_ssl_cert_verify                   = $::os_service_default,
  $driver_ssl_cert_path                     = $::os_service_default,
  $manage_volume_type                       = false,
  $extra_options                            = {},
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
    "${name}/powerflex_allow_migration_during_rebuild": value => $powerflex_allow_migration_during_rebuild;
    "${name}/powerflex_allow_non_padded_volumes":       value => $powerflex_allow_non_padded_volumes;
    "${name}/powerflex_max_over_subscription_ratio":    value => $powerflex_max_over_subscription_ratio;
    "${name}/powerflex_rest_server_port":               value => $powerflex_rest_server_port;
    "${name}/powerflex_round_volume_capacity":          value => $powerflex_round_volume_capacity;
    "${name}/powerflex_server_api_version":             value => $powerflex_server_api_version;
    "${name}/powerflex_unmap_volume_before_deletion":   value => $powerflex_unmap_volume_before_deletion;
    "${name}/san_thin_provision":                       value => $san_thin_provision;
    "${name}/driver_ssl_cert_verify":                   value => $driver_ssl_cert_verify;
    "${name}/driver_ssl_cert_path":                     value => $driver_ssl_cert_path;
  }
  if $manage_volume_type {
    cinder_type { $name:
      ensure     => present,
      properties => ["volume_backend_name=${name}"],
    }
  }

  create_resources('cinder_config', $extra_options)

}
