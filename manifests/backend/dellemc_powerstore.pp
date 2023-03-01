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
  $powerstore_ports            = $facts['os_service_default'],
  $storage_protocol            = 'iSCSI',
  $volume_backend_name         = $name,
  $backend_availability_zone   = $facts['os_service_default'],
  $manage_volume_type          = false,
  $extra_options               = {},
) {

  include cinder::deps

  validate_legacy(Boolean, 'validate_bool', $manage_volume_type)

  if $storage_protocol == 'iSCSI' {
    $driver = 'dell_emc.powerstore.driver.PowerStoreDriver'
  }
  elsif $storage_protocol == 'FC' {
    $driver = 'dell_emc.powerstore.driver.PowerStoreDriver'
  }
  else {
    fail('The cinder::backend::dellemc_powerstore storage_protocol specified is not valid. It should be iSCSI or FC')
  }

  cinder_config {
    "${name}/volume_backend_name":       value => $volume_backend_name;
    "${name}/backend_availability_zone": value => $backend_availability_zone;
    "${name}/volume_driver":             value => "cinder.volume.drivers.${driver}";
    "${name}/san_ip":                    value => $san_ip;
    "${name}/san_login":                 value => $san_login;
    "${name}/san_password":              value => $san_password, secret => true;
    "${name}/powerstore_ports":          value => $powerstore_ports;
    "${name}/storage_protocol":          value => $storage_protocol;
  }

  cinder_config {
    "${name}/powerstore_appliances": ensure => absent;
  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => ["volume_backend_name=${volume_backend_name}"],
    }
  }

  create_resources('cinder_config', $extra_options)

}
