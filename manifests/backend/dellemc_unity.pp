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
# [*backend_availability_zone*]
#   (Optional) Availability zone for this volume backend.
#   If not set, the storage_availability_zone option value
#   is used as the default for all backends.
#   Defaults to $facts['os_service_default'].
#
# [*reserved_percentage*]
#   (Optional) The percentage of backend capacity is reserved.
#   Defaults to $facts['os_service_default'].
#
# [*unity_io_ports*]
#   (optional) A list of iSCSI or FC ports to be used. Each port can be
#   Unix-style glob expressions. The Unity Unisphere API port.
#   Defaults to $facts['os_service_default']
#
# [*unity_storage_pool_names*]
#   (optional) A list of storage pool names to be used.
#   Defaults to $facts['os_service_default']
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
  $volume_backend_name        = $name,
  $backend_availability_zone  = $facts['os_service_default'],
  $reserved_percentage        = $facts['os_service_default'],
  $unity_io_ports             = $facts['os_service_default'],
  $unity_storage_pool_names   = $facts['os_service_default'],
  Boolean $manage_volume_type = false,
  Hash $extra_options         = {},
) {

  include cinder::deps

  $driver = 'dell_emc.unity.Driver'
  cinder_config {
    "${name}/volume_backend_name":       value => $volume_backend_name;
    "${name}/backend_availability_zone": value => $backend_availability_zone;
    "${name}/reserved_percentage":       value => $reserved_percentage;
    "${name}/volume_driver":             value => "cinder.volume.drivers.${driver}";
    "${name}/san_ip":                    value => $san_ip;
    "${name}/san_login":                 value => $san_login;
    "${name}/san_password":              value => $san_password, secret => true;
    "${name}/storage_protocol":          value => $storage_protocol;
    "${name}/unity_io_ports":            value => join(any2array($unity_io_ports), ',');
    "${name}/unity_storage_pool_names":  value => join(any2array($unity_storage_pool_names), ',');
  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => ["volume_backend_name=${volume_backend_name}"],
    }
  }

  create_resources('cinder_config', $extra_options)

}
