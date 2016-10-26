#
# == Define: cinder::backend::emc_vnx
#
# Setup Cinder to use the EMC VNX driver.
# Compatible for multiple backends
#
# == Parameters
#
# [*volume_backend_name*]
#   (optional) Allows for the volume_backend_name to be separate of $name.
#   Defaults to: $name
#
# [*san_ip*]
#   (required) IP address of SAN controller.
#
# [*san_password*]
#   (required) Password of SAN controller.
#
# [*san_login*]
#   (optional) Login of SAN controller.
#   Defaults to : 'admin'
#
# [*storage_vnx_pool_name*]
#   (required) Storage pool name.
#
# [*default_timeout*]
#   (optional) Default timeout for CLI operations in minutes.
#   Defaults to: '10'
#
# [*max_luns_per_storage_group*]
#   (optional) Default max number of LUNs in a storage group.
#   Defaults to: '256'
#
# [*package_ensure*]
#   (optional) The state of the package
#   Defaults to: 'present'
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend stanza
#   Defaults to: {}
#   Example :
#     { 'emc_vnx_backend/param1' => { 'value' => value1 } }
#
# [*volume_driver*]
#   (optional) The EMC VNX Driver you want to use
#   Defaults to cinder.volume.drivers.emc.vnx.driver.EMCVNXDriver
#
# [*storage_protocol*]
#   (optional) Which storage protocol to use.
#   Defaults to 'iscsi'
#
# [*initiator_auto_registration*]
#   (optinal) Automatically register initiators.
#   Boolean value.
#   Defaults to $::os_service_default
#
# [*storage_vnx_auth_type*]
#   (optional) VNX authentication scope type.
#   Defaults to $::os_service_default
#
# [*storage_vnx_security_file_dir*]
#   (optional) Directory path that contains the VNX security file.
#   Make sure the security file is generated first.
#   Defaults to $::os_service_default
#
# [*naviseccli_path*]
#   (optional) Naviseccli Path.
#   Defaults to $::os_service_default
#
# [*manage_volume_type*]
#   (Optional) Whether or not manage Cinder Volume type.
#   If set to true, a Cinde Volume type will be created
#   with volume_backend_name=$volume_backend_name key/value.
#   Defaults to false.
#
# == Deprecated Parameters
#
# [*iscsi_ip_address*]
#   (optional) DEPRECATED The IP address that the iSCSI daemon is listening on
#   Defaults to undef
#
define cinder::backend::emc_vnx (
  $san_ip,
  $san_password,
  $storage_vnx_pool_name,
  $default_timeout               = '10',
  $max_luns_per_storage_group    = '256',
  $package_ensure                = 'present',
  $san_login                     = 'admin',
  $volume_backend_name           = $name,
  $extra_options                 = {},
  $volume_driver                 = 'cinder.volume.drivers.emc.vnx.driver.EMCVNXDriver',
  $storage_protocol              = 'iscsi',
  $initiator_auto_registration   = $::os_service_default,
  $storage_vnx_auth_type         = $::os_service_default,
  $storage_vnx_security_file_dir = $::os_service_default,
  $naviseccli_path               = $::os_service_default,
  $manage_volume_type            = false,
  # Deprecated
  $iscsi_ip_address              = undef,
) {

  include ::cinder::deps
  include ::cinder::params

  if $iscsi_ip_address {
    warning('iscsi_ip_address is deprecated, has no effect and will be removed in a future release')
  }

  cinder_config {
    "${name}/default_timeout":                 value => $default_timeout;
    "${name}/max_luns_per_storage_group":      value => $max_luns_per_storage_group;
    "${name}/naviseccli_path":                 value => $naviseccli_path;
    "${name}/san_ip":                          value => $san_ip;
    "${name}/san_login":                       value => $san_login;
    "${name}/san_password":                    value => $san_password;
    "${name}/storage_vnx_pool_name":           value => $storage_vnx_pool_name;
    "${name}/volume_backend_name":             value => $volume_backend_name;
    "${name}/volume_driver":                   value => $volume_driver;
    "${name}/storage_protocol":                value => $storage_protocol;
    "${name}/initiator_auto_registration":     value => $initiator_auto_registration;
    "${name}/storage_vnx_authentication_type": value => $storage_vnx_auth_type;
    "${name}/storage_vnx_security_file_dir":   value => $storage_vnx_security_file_dir;
  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => ["volume_backend_name=${volume_backend_name}"],
    }
  }

  create_resources('cinder_config', $extra_options)

}
