# == define: cinder::backend::vxflexos
#
# Configures Cinder to use the Dell EMC VxFlexOS Block Storage driver
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
# [*vxflexos_storage_pools*]
#   (String) (required)  Storage Pools. Comma separated list of storage pools used to provide volumes.
#   Each pool should be specified as a protection_domain_name:storage_pool_name value
#
# [*volume_backend_name*]
#   (optional) The name of the cinder::backend::vxflexos_ ressource
#   Defaults to $name.
#
# [*backend_availability_zone*]
#   (optional) Availability zone for this volume backend.
#   If not set, the storage_availability_zone option value
#   is used as the default for all backends.
#   Defaults to $::os_service_default.
#
# [*vxflexos_allow_migration_during_rebuild*]
#   (optional) (Boolean) Allow volume migration during rebuild.
#   Defaults to $::os_service_default
#
# [*vxflexos_allow_non_padded_volumes*]
#   (optional) (Boolean) Allow volumes to be created in Storage Pools
#   when zero padding is disabled.
#   Defaults to $::os_service_default
#
# [*vxflexos_max_over_subscription_ratio*]
#   (optional) (Floating point) max_over_subscription_ratio setting for the driver.
#   Maximum value allowed is 10.0.
#   Defaults to $::os_service_default
#
# [*vxflexos_rest_server_port*]
#   (optional) (String) The TCP port to use for communication with the storage
#   system or proxy.
#   Defaults to $::os_service_default
#
# [*vxflexos_round_volume_capacity*]
#  (optional) (Boolean) Round volume sizes up to 8GB boundaries. VxFlex OS/ScaleIO
#  requires volumes to be sized in multiples of 8GB. If set to False,
#  volume creation will fail for volumes not sized properly
#  Defaults to $::os_service_default
#
# [*vxflexos_server_api_version*]
#   (optional) (String) VxFlex OS/ScaleIO API version. This value should be left as the
#   default value unless otherwise instructed by technical support.
#
# [*vxflexos_unmap_volume_before_deletion*]
#   (optional) (Boolean) Unmap volumes before deletion.
#   Defaults to $::os_service_default
#
# [*san_thin_provision*]
#   (optional) (Boolean) Wheater to use thin provisioning or not.
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
#     { 'vxflexos_backend/param1' => { 'value' => value1 } }
#
# === Examples
#
#  cinder::backend::vxflexos_ { 'myBackend':
#    san_login              => 'admin',
#    san_password           => 'password',
#    san_ip                 => 'vxflexos_.mycorp.com',
#    vxflexos_storage_pools => 'domain1:pool1',
#  }
#
define cinder::backend::dellemc_vxflexos(
  $san_login,
  $san_password,
  $san_ip,
  $vxflexos_storage_pools,
  $volume_backend_name                     = $name,
  $backend_availability_zone               = $::os_service_default,
  $vxflexos_allow_migration_during_rebuild = $::os_service_default,
  $vxflexos_allow_non_padded_volumes       = $::os_service_default,
  $vxflexos_max_over_subscription_ratio    = $::os_service_default,
  $vxflexos_rest_server_port               = $::os_service_default,
  $vxflexos_round_volume_capacity          = $::os_service_default,
  $vxflexos_server_api_version             = $::os_service_default,
  $vxflexos_unmap_volume_before_deletion   = $::os_service_default,
  $san_thin_provision                      = $::os_service_default,
  $driver_ssl_cert_verify                  = $::os_service_default,
  $driver_ssl_cert_path                    = $::os_service_default,
  $manage_volume_type                      = false,
  $extra_options                           = {},
) {

  include cinder::deps

  warning('The cinder::backend::dellemc_vxflexos is rebranded and deprecated. It will be removed \
    in W-release, please use cinder::backend::dellemc_powerflex resource instead.')

  cinder_config {
    "${name}/volume_driver":                           value => 'cinder.volume.drivers.dell_emc.vxflexos.driver.VxFlexOSDriver';
    "${name}/san_login":                               value => $san_login;
    "${name}/san_password":                            value => $san_password, secret => true;
    "${name}/san_ip":                                  value => $san_ip;
    "${name}/vxflexos_storage_pools":                  value => $vxflexos_storage_pools;
    "${name}/volume_backend_name":                     value => $volume_backend_name;
    "${name}/backend_availability_zone":               value => $backend_availability_zone;
    "${name}/vxflexos_allow_migration_during_rebuild": value => $vxflexos_allow_migration_during_rebuild;
    "${name}/vxflexos_allow_non_padded_volumes":       value => $vxflexos_allow_non_padded_volumes;
    "${name}/vxflexos_max_over_subscription_ratio":    value => $vxflexos_max_over_subscription_ratio;
    "${name}/vxflexos_rest_server_port":               value => $vxflexos_rest_server_port;
    "${name}/vxflexos_round_volume_capacity":          value => $vxflexos_round_volume_capacity;
    "${name}/vxflexos_server_api_version":             value => $vxflexos_server_api_version;
    "${name}/vxflexos_unmap_volume_before_deletion":   value => $vxflexos_unmap_volume_before_deletion;
    "${name}/san_thin_provision":                      value => $san_thin_provision;
    "${name}/driver_ssl_cert_verify":                  value => $driver_ssl_cert_verify;
    "${name}/driver_ssl_cert_path":                    value => $driver_ssl_cert_path;
  }
  if $manage_volume_type {
    cinder_type { $name:
      ensure     => present,
      properties => ["volume_backend_name=${name}"],
    }
  }

  create_resources('cinder_config', $extra_options)

}
