# == Class: cinder::volume::nexenta
#
# Setups Cinder with Nexenta volume driver.
#
# === Parameters
#
# [*nexenta_user*]
#   (required) User name to connect to Nexenta SA.
#
# [*nexenta_password*]
#   (required) Password to connect to Nexenta SA.
#
# [*nexenta_host*]
#   (required) IP address of Nexenta SA.
#
# [*nexenta_volume*]
#   (optional) Pool on SA that will hold all volumes. Defaults to 'cinder'.
#
# [*nexenta_target_prefix*]
#   (optional) IQN prefix for iSCSI targets. Defaults to 'iqn:'.
#
# [*nexenta_target_group_prefix*]
#   (optional) Prefix for iSCSI target groups on SA. Defaults to 'cinder/'.
#
# [*nexenta_blocksize*]
#   (optional) Block size for volumes. Defaults to '8k'.
#
# [*nexenta_sparse*]
#   (optional) Flag to create sparse volumes. Defaults to true.
#
class cinder::volume::nexenta (
  $nexenta_user,
  $nexenta_password,
  $nexenta_host,
  $nexenta_volume               = 'cinder',
  $nexenta_target_prefix        = 'iqn:',
  $nexenta_target_group_prefix  = 'cinder/',
  $nexenta_blocksize            = '8k',
  $nexenta_sparse               = true
) {

  cinder_config {
    'DEFAULT/nexenta_user':                 value => $nexenta_user;
    'DEFAULT/nexenta_password':             value => $nexenta_password;
    'DEFAULT/nexenta_host':                 value => $nexenta_host;
    'DEFAULT/nexenta_volume':               value => $nexenta_volume;
    'DEFAULT/nexenta_target_prefix':        value => $nexenta_target_prefix;
    'DEFAULT/nexenta_target_group_prefix':  value => $nexenta_target_group_prefix;
    'DEFAULT/nexenta_blocksize':            value => $nexenta_blocksize;
    'DEFAULT/nexenta_sparse':               value => $nexenta_sparse;
    'DEFAULT/volume_driver':                value => 'cinder.volume.drivers.nexenta.volume.NexentaDriver';
  }
}
