# == Class: cinder::volume::iscsi
#
# Configures Cinder volume ISCSI driver.
#
# === Parameters
#
# [*iscsi_ip_address*]
#   (Required) The IP address that the iSCSI daemon is listening on
#
# [*volume_driver*]
#   (Optional) Driver to use for volume creation
#   Defaults to 'cinder.volume.drivers.lvm.LVMISCSIDriver'.
#
# [*volume_group*]
#   (Optional) Name for the VG that will contain exported volumes
#   Defaults to 'cinder-volumes'.
#
# [*iscsi_helper*]
#   (Optional) iSCSI target user-land tool to use.
#   Defaults to '$::cinder::params::iscsi_helper'.
#
class cinder::volume::iscsi (
  $iscsi_ip_address,
  $volume_driver     = 'cinder.volume.drivers.lvm.LVMISCSIDriver',
  $volume_group      = 'cinder-volumes',
  $iscsi_helper      = $::cinder::params::iscsi_helper,
) {

  include cinder::params

  cinder::backend::iscsi { 'DEFAULT':
    iscsi_ip_address => $iscsi_ip_address,
    volume_driver    => $volume_driver,
    volume_group     => $volume_group,
    iscsi_helper     => $iscsi_helper
  }
}
