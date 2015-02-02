# == Class: cinder::volume::emc_enx
#
# Configures Cinder volume EMC VNX driver.
# Parameters are particular to each volume driver.
#
# === Parameters
#
# [*iscsi_initiators*]
#
#   (required) IP addresses of the iSCSI initiator ports on all OpenStack nodes which want to connec to VNX via iSCSI
#   Example: {"node1hostname":["10.0.0.1", "10.0.0.2"],"node2hostname":["10.0.0.3"]}
#   Default to: none
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
#   (optonal) Default timeout for CLI operations in minutes.
#   Defaults to: '10'
#
# [*max_luns_per_storage_group*]
#   (optonal) Default max number of LUNs in a storage group.
#   Defaults to: '256'
#
class cinder::volume::emc_vnx(
  $iscsi_initiators,
  $san_ip,
  $san_password,
  $storage_vnx_pool_name,
  $default_timeout            = '10',
  $max_luns_per_storage_group = '256',
  $package_ensure             = 'present',
  $san_login                  = 'admin',
) {

  cinder::backend::emc_vnx { 'DEFAULT':
    default_timeout            => $default_timeout,
    iscsi_initiators           => $iscsi_initiators,
    max_luns_per_storage_group => $max_luns_per_storage_group,
    package_ensure             => $package_ensure,
    san_ip                     => $san_ip,
    san_login                  => $san_login,
    san_password               => $san_password,
    storage_vnx_pool_name      => $storage_vnx_pool_name,
  }
}
