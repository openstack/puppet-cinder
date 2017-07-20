# == define: cinder::backend::dellemc_unity
#
# Configure the Dell EMC Unity Driver for cinder.
#
# === Parameters
#
# [*san_ip*]
#   (required) IP address of Unity Unisphere.
#
# [*san_login*]
#   (required) Unity Unisphere user name.
#
# [*san_password*]
#   (required) Unity Unisphere user password.
#
# [*storage_protocol*]
#   (required) The Storage protocol, iSCSI or FC.
#
# [*volume_backend_name*]
#   (optional) The storage backend name.
#   Defaults to the $name of the backend
#
# [*unity_io_ports*]
#   (optional) A comma-separated list of iSCSI or FC ports to be used.
#   Each port can be Unix-style glob expressions. The Unity Unisphere API port.
#   Defaults to $::os_service_default
#
# [*unity_storage_pool_names*]
#   (optional) A comma-separated list of storage pool names to be used.
#   Defaults to $::os_service_default
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend stanza.
#   Defaults to: {}
#   Example:
#     { 'dellemc_unity_backend/param1' => { 'value' => value1 } }
#
# [*manage_volume_type*]
#   (Optional) Whether or not manage Cinder Volume type.
#   If set to true, a Cinder Volume type will be created
#   with volume_backend_name=$volume_backend_name key/value.
#   Defaults to false.
#
define cinder::backend::dellemc_unity (
  $san_ip,
  $san_login,
  $san_password,
  $storage_protocol,
  $volume_backend_name      = $name,
  $unity_io_ports           = $::os_service_default,
  $unity_storage_pool_names = $::os_service_default,
  $manage_volume_type       = false,
  $extra_options            = {},
) {

  include ::cinder::deps

  $driver = 'dell_emc.unity.Driver'
  cinder_config {
    "${name}/volume_backend_name":      value => $volume_backend_name;
    "${name}/volume_driver":            value => "cinder.volume.drivers.${driver}";
    "${name}/san_ip":                   value => $san_ip;
    "${name}/san_login":                value => $san_login;
    "${name}/san_password":             value => $san_password, secret => true;
    "${name}/storage_protocol":         value => $storage_protocol;
    "${name}/unity_io_ports":           value => $unity_io_ports;
    "${name}/unity_storage_pool_names": value => $unity_storage_pool_names;
  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => ["volume_backend_name=${volume_backend_name}"],
    }
  }

  create_resources('cinder_config', $extra_options)

}
