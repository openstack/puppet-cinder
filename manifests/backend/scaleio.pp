# == define: cinder::backend::scaleio
#
# Configures Cinder to use the EMC ScaleIO Block Storage driver
# Compatible for multiple backends
#
# === Parameters
#
# [*volume_backend_name*]
#   (optional) The name of the cinder::backend::scaleio ressource
#   Defaults to $name.
#
# [*sio_login*]
#   (required) Administrative user account name used to access the storage
#   system or proxy server.
#
# [*sio_password*]
#   (required) Password for the administrative user account specified in the
#   sio_login option.
#
# [*sio_server_hostname*]
#   (required) The hostname (or IP address) for the storage system or proxy
#   server.
#
# [*sio_server_port*]
#   (optional) The TCP port to use for communication with the storage
#   system or proxy.
#   Defaults to $::os_service_default
#
# [*sio_verify_server_certificate*]
#   (optional) Verify the server certificate
#   Defaults to $::os_service_default
#
# [*sio_server_certificate_path*]
#   (optional) Server certificate path.
#   Defaults to $::os_service_default
#
# [*sio_protection_domain_id*]
#   (String) Protection Domain ID.
#
# [*sio_protection_domain_name*]
#   (String) Protection Domain name.
#
# [*sio_storage_pool_id*]
#   (String) Storage Pool ID.
#
# [*sio_storage_pool_name*]
#   (String) Storage Pool name.
#
# [*sio_storage_pools*]
#   (String) Storage Pools.
#
# [*sio_round_volume_capacity*]
#   (Boolean) Round up volume capacity.
#   Defaults to $::os_service_default
#
# [*sio_unmap_volume_before_deletion*]
#   (optionla) (Boolean) Unmap volume before deletion.
#   Defaults to $::os_service_default
#
# [*sio_max_over_subscription_ratio*]
#   (optional) (Floating point) max_over_subscription_ratio settinG
#   for the ScaleIO driver. This replaces the general
#   max_over_subscription_ratio which has no effect in this driver.
#   Maximum value allowed for ScaleIO is 10.0.
#   Defaults to $::os_service_default
#
# [*sio_thin_provision*]
#   (optional) (Boolean) Wheater to use thin provisioning or not.
#   Defaults to $::os_service_default
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
#     { 'sio_backend/param1' => { 'value' => value1 } }
#
# === Examples
#
#  cinder::backend::scaleio { 'myBackend':
#    sio_login           => 'admin',
#    sio_password        => 'password',
#    sio_server_hostname => 'scaleio.mycorp.com',
#    sio_protection_domain_name => 'domain1',
#    sio_storage_pool_name => 'pool1',
#    sio_storage_pools => 'domain1:pool1',
#  }
#
# === Authors
#
# Harald Jensas <hjensas@redhat.com>
#
# === Copyright
#
# Copyright 2016 Red Hat, Inc.
#
define cinder::backend::scaleio (
  $sio_login,
  $sio_password,
  $sio_server_hostname,
  $sio_protection_domain_id,
  $sio_protection_domain_name,
  $sio_storage_pool_id,
  $sio_storage_pool_name,
  $sio_storage_pools,
  $volume_backend_name              = $name,
  $sio_server_port                  = $::os_service_default,
  $sio_verify_server_certificate    = $::os_service_default,
  $sio_server_certificate_path      = $::os_service_default,
  $sio_round_volume_capacity        = $::os_service_default,
  $sio_unmap_volume_before_deletion = $::os_service_default,
  $sio_max_over_subscription_ratio  = $::os_service_default,
  $sio_thin_provision               = $::os_service_default,
  $manage_volume_type               = false,
  $extra_options                    = {},
) {

  cinder_config {
    "${name}/volume_backend_name":              value => $volume_backend_name;
    "${name}/volume_driver":                    value => 'cinder.volume.drivers.dell_emc.scaleio.driver.ScaleIODriver';
    "${name}/san_login":                        value => $sio_login;
    "${name}/san_password":                     value => $sio_password, secret => true;
    "${name}/san_ip":                           value => $sio_server_hostname;
    "${name}/sio_rest_server_port":             value => $sio_server_port;
    "${name}/sio_verify_server_certificate":    value => $sio_verify_server_certificate;
    "${name}/sio_server_certificate_path":      value => $sio_server_certificate_path;
    "${name}/sio_protection_domain_id":         value => $sio_protection_domain_id;
    "${name}/sio_protection_domain_name":       value => $sio_protection_domain_name;
    "${name}/sio_storage_pool_id":              value => $sio_storage_pool_id;
    "${name}/sio_storage_pool_name":            value => $sio_storage_pool_name;
    "${name}/sio_storage_pools":                value => $sio_storage_pools;
    "${name}/sio_round_volume_capacity":        value => $sio_round_volume_capacity;
    "${name}/sio_unmap_volume_before_deletion": value => $sio_unmap_volume_before_deletion;
    "${name}/sio_max_over_subscription_ratio":  value => $sio_max_over_subscription_ratio;
    "${name}/san_thin_provision":               value => $sio_thin_provision;
  }

  if $manage_volume_type {
    cinder_type { $name:
      ensure     => present,
      properties => ["volume_backend_name=${name}"],
    }
  }

  create_resources('cinder_config', $extra_options)

}
