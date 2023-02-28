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
# [*backend_availability_zone*]
#   (Optional) Availability zone for this volume backend.
#   If not set, the storage_availability_zone option value
#   is used as the default for all backends.
#   Defaults to $::os_service_default.
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
# [*storage_vnx_pool_names*]
#   (required) Storage pool names.
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
#   Defaults to cinder.volume.drivers.dell_emc.vnx.driver.VNXDriver
#
# [*storage_protocol*]
#   (optional) Which storage protocol to use.
#   Defaults to 'iscsi'
#
# [*destroy_empty_storage_group*]
#   (optional) Destroy storage group when the last LUN is removed from it.
#   Defaults to $::os_service_default
#
# [*iscsi_initiators*]
#   (optional) Mapping between hostname and its iSCSI initiator IP addresses.
#   Defaults to $::os_service_default
#
# [*io_port_list*]
#   (optional) List of iSCSI or FC ports to be used in Nova or Cinder.
#   Defaults to $::os_service_default
#
# [*initiator_auto_registration*]
#   (optional) Automatically register initiators.
#   Boolean value.
#   Defaults to $::os_service_default
#
# [*initiator_auto_deregistration*]
#   (optional) Automatically deregister initiators after the related storage
#   group is destroyed.
#   Boolean value.
#   Defaults to $::os_service_default
#
# [*force_delete_lun_in_storagegroup*]
#   (optional) Delete a LUN even if it is in Storage Groups.
#   Defaults to $::os_service_default
#
# [*ignore_pool_full_threshold*]
#   (optional) Force LUN creation even if the full threshold of pool is
#   reached.
#   Defaults to $::os_service_default
#
# [*vnx_async_migrate*]
#   (optional) Always use asynchronous migration during volume cloning and
#   creating from snapshot.
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
#   If set to true, a Cinder Volume type will be created
#   with volume_backend_name=$volume_backend_name key/value.
#   Defaults to false.
#
define cinder::backend::emc_vnx (
  $san_ip,
  $san_password,
  $storage_vnx_pool_names,
  $default_timeout                  = '10',
  $max_luns_per_storage_group       = '256',
  $package_ensure                   = 'present',
  $san_login                        = 'admin',
  $volume_backend_name              = $name,
  $backend_availability_zone        = $::os_service_default,
  $extra_options                    = {},
  $volume_driver                    = 'cinder.volume.drivers.dell_emc.vnx.driver.VNXDriver',
  $storage_protocol                 = 'iscsi',
  $destroy_empty_storage_group      = $::os_service_default,
  $iscsi_initiators                 = $::os_service_default,
  $io_port_list                     = $::os_service_default,
  $initiator_auto_registration      = $::os_service_default,
  $initiator_auto_deregistration    = $::os_service_default,
  $force_delete_lun_in_storagegroup = $::os_service_default,
  $ignore_pool_full_threshold       = $::os_service_default,
  $vnx_async_migrate                = $::os_service_default,
  $storage_vnx_auth_type            = $::os_service_default,
  $storage_vnx_security_file_dir    = $::os_service_default,
  $naviseccli_path                  = $::os_service_default,
  $manage_volume_type               = false,
) {

  include cinder::deps
  include cinder::params

  validate_legacy(Boolean, 'validate_bool', $manage_volume_type)

  cinder_config {
    "${name}/default_timeout":                  value => $default_timeout;
    "${name}/max_luns_per_storage_group":       value => $max_luns_per_storage_group;
    "${name}/naviseccli_path":                  value => $naviseccli_path;
    "${name}/san_ip":                           value => $san_ip;
    "${name}/san_login":                        value => $san_login;
    "${name}/san_password":                     value => $san_password, secret => true;
    "${name}/storage_vnx_pool_names":           value => join(any2array($storage_vnx_pool_names), ',');
    "${name}/volume_backend_name":              value => $volume_backend_name;
    "${name}/backend_availability_zone":        value => $backend_availability_zone;
    "${name}/volume_driver":                    value => $volume_driver;
    "${name}/storage_protocol":                 value => $storage_protocol;
    "${name}/destroy_empty_storage_group":      value => $destroy_empty_storage_group;
    "${name}/iscsi_initiators":                 value => $iscsi_initiators;
    "${name}/io_port_list":                     value => join(any2array($io_port_list), ',');
    "${name}/initiator_auto_registration":      value => $initiator_auto_registration;
    "${name}/initiator_auto_deregistration":    value => $initiator_auto_deregistration;
    "${name}/force_delete_lun_in_storagegroup": value => $force_delete_lun_in_storagegroup;
    "${name}/ignore_pool_full_threshold":       value => $ignore_pool_full_threshold;
    "${name}/vnx_async_migrate":                value => $vnx_async_migrate;
    "${name}/storage_vnx_authentication_type":  value => $storage_vnx_auth_type;
    "${name}/storage_vnx_security_file_dir":    value => $storage_vnx_security_file_dir;
  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => ["volume_backend_name=${volume_backend_name}"],
    }
  }

  create_resources('cinder_config', $extra_options)

}
