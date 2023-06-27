#
# == Define: cinder::backend::dellemc_powermax
#
# Setup Cinder to use the Dell EMC PowerMax Driver
# Compatible for multiple backends
#
# == Parameters
#
# [*san_ip*]
#   (required) IP address of PowerMax Unisphere.
#
# [*san_login*]
#   (required) PowerMax Unisphere user name.
#
# [*san_password*]
#   (required) PowerMax Unisphere user password.
#
# [*powermax_array*]
#   (required) Serial number of the PowerMax Array.
#
# [*powermax_srp*]
#   (required) Storage resource pool on array to use for provisioning.
#
# [*powermax_port_groups*]
#   (required) List of port groups.
#
# [*powermax_storage_protocol*]
#   (optional) The Storage protocol, iSCSI or FC.
#   This will determine
#   which Volume Driver will be configured; PowerMaxISCSIDriver or PowerMaxFCDriver.
#   Defaults to 'iSCSI'

# [*volume_backend_name*]
#   (optional) Allows for the volume_backend_name to be separate of $name.
#   Defaults to: $name
#
# [*backend_availability_zone*]
#   (Optional) Availability zone for this volume backend.
#   If not set, the storage_availability_zone option value
#   is used as the default for all backends.
#   Defaults to $::os_service_default.
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
#     { 'dellemc_powermax_backend/param1' => { 'value' => value1 } }#
#
define cinder::backend::dellemc_powermax (
  $san_ip,
  $san_login,
  $san_password,
  $powermax_array,
  $powermax_srp,
  $powermax_port_groups,
  $powermax_storage_protocol     = 'iSCSI',
  $volume_backend_name           = $name,
  $backend_availability_zone     = $::os_service_default,
  $extra_options                 = {},
  $manage_volume_type            = false,
) {

  include cinder::deps
  include cinder::params

  if $powermax_storage_protocol == 'iSCSI' {
    $volume_driver = 'cinder.volume.drivers.dell_emc.powermax.iscsi.PowerMaxISCSIDriver'
  }
  elsif $powermax_storage_protocol == 'FC' {
    $volume_driver = 'cinder.volume.drivers.dell_emc.powermax.fc.PowerMaxFCDriver'
  }
  else {
    fail('The cinder::backend::dellemc_powermax powermax_storage_protocol specified is not valid. It should be iSCSI or FC')
  }

  cinder_config {
    "${name}/volume_backend_name":       value => $volume_backend_name;
    "${name}/backend_availability_zone": value => $backend_availability_zone;
    "${name}/volume_driver":             value => $volume_driver;
    "${name}/san_ip":                    value => $san_ip;
    "${name}/san_login":                 value => $san_login;
    "${name}/san_password":              value => $san_password, secret => true;
    "${name}/powermax_array":            value => $powermax_array;
    "${name}/powermax_srp":              value => $powermax_srp;
    "${name}/powermax_port_groups":      value => $powermax_port_groups;
  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => ["volume_backend_name=${volume_backend_name}"],
    }
  }

  ensure_packages( 'pywbem', {
    ensure => present,
    name   => $::cinder::params::pywbem_package_name,
    tag    => 'cinder-support-package'})

  create_resources('cinder_config', $extra_options)

}
