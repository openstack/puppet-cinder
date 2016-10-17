# == Class: cinder::volume::emc_enx
#
# Configures Cinder volume EMC VNX driver.
# Parameters are particular to each volume driver.
#
# === Parameters
#
# [*package_ensure*]
#   (Optional) State of the package
#   Defaults to 'present'.
#
# [*san_ip*]
#   (Required) IP address of SAN controller.
#
# [*san_password*]
#   (Required) Password of SAN controller.
#
# [*san_login*]
#   (Optional) Login of SAN controller.
#   Defaults to : 'admin'
#
# [*storage_vnx_pool_name*]
#   (Required) Storage pool name.
#
# [*default_timeout*]
#   (Optonal) Default timeout for CLI operations in minutes.
#   Defaults to: '10'
#
# [*max_luns_per_storage_group*]
#   (Optonal) Default max number of LUNs in a storage group.
#   Defaults to: '256'
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend stanza
#   Defaults to: {}
#   Example :
#     { 'emc_vnx_backend/param1' => { 'value' => value1 } }
#
# [*volume_driver*]
#   (optional) The EMC VNX Driver you want to use
#   Defaults to cinder.volume.drivers.emc.emc_cli_iscsi.EMCCLIISCSIDriver
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
# == Deprecated Parameters
#
# [*iscsi_ip_address*]
#   (Optional) DEPRECATED The IP address that the iSCSI daemon is listening on
#   Defaults to undef
#

class cinder::volume::emc_vnx(
  $san_ip,
  $san_password,
  $storage_vnx_pool_name,
  $default_timeout               = '10',
  $max_luns_per_storage_group    = '256',
  $package_ensure                = 'present',
  $san_login                     = 'admin',
  $extra_options                 = {},
  $volume_driver                 = 'cinder.volume.drivers.emc.emc_cli_iscsi.EMCCLIISCSIDriver',
  $initiator_auto_registration   = $::os_service_default,
  $storage_vnx_auth_type         = $::os_service_default,
  $storage_vnx_security_file_dir = $::os_service_default,
  $naviseccli_path               = $::os_service_default,
  # Deprecated
  $iscsi_ip_address              = undef,
) {

  include ::cinder::deps

  warning('Usage of cinder::volume::emc_vnx is deprecated, please use
cinder::backend::emc_vnx instead.')

  cinder::backend::emc_vnx { 'DEFAULT':
    default_timeout               => $default_timeout,
    iscsi_ip_address              => $iscsi_ip_address,
    max_luns_per_storage_group    => $max_luns_per_storage_group,
    package_ensure                => $package_ensure,
    san_ip                        => $san_ip,
    san_login                     => $san_login,
    san_password                  => $san_password,
    storage_vnx_pool_name         => $storage_vnx_pool_name,
    extra_options                 => $extra_options,
    volume_driver                 => $volume_driver,
    initiator_auto_registration   => $initiator_auto_registration,
    storage_vnx_auth_type         => $storage_vnx_auth_type,
    storage_vnx_security_file_dir => $storage_vnx_security_file_dir,
    naviseccli_path               => $naviseccli_path,
  }

}
