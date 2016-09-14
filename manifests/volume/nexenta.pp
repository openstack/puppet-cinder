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
#   (optional) Pool on SA that will hold all volumes.
#   Defaults to 'cinder'.
#
# [*nexenta_target_prefix*]
#   (optional) IQN prefix for iSCSI targets.
#   Defaults to 'iqn:'.
#
# [*nexenta_target_group_prefix*]
#   (optional) Prefix for iSCSI target groups on SA.
#   Defaults to 'cinder/'.
#
# [*nexenta_blocksize*]
#   (optional) Block size for volumes.
#   Defaults to '8k'.
#
# [*nexenta_sparse*]
#   (optional) Flag to create sparse volumes.
#   Defaults to true.
#
# [*nexenta_rest_port*]
#   (optional) HTTP port for REST API.
#   Defaults to '8457'.
#
# [*volume_driver*]
#   (required) Nexenta driver to use.
#   Defaults to: 'cinder.volume.drivers.nexenta.iscsi.NexentaISCSIDriver'.
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend stanza
#   Defaults to: {}
#   Example :
#     { 'nexenta_backend/param1' => { 'value' => value1 } }
#
class cinder::volume::nexenta (
  $nexenta_user,
  $nexenta_password,
  $nexenta_host,
  $nexenta_volume               = 'cinder',
  $nexenta_target_prefix        = 'iqn:',
  $nexenta_target_group_prefix  = 'cinder/',
  $nexenta_blocksize            = '8192',
  $nexenta_sparse               = true,
  $nexenta_rest_port            = '8457',
  $volume_driver                = 'cinder.volume.drivers.nexenta.iscsi.NexentaISCSIDriver',
  $extra_options                = {},
) {

  include ::cinder::deps

  warning('Usage of cinder::volume::nexenta is deprecated, please use
cinder::backend::nexenta instead.')

  cinder::backend::nexenta { 'DEFAULT':
    nexenta_user                => $nexenta_user,
    nexenta_password            => $nexenta_password,
    nexenta_host                => $nexenta_host,
    nexenta_volume              => $nexenta_volume,
    nexenta_target_prefix       => $nexenta_target_prefix,
    nexenta_target_group_prefix => $nexenta_target_group_prefix,
    nexenta_blocksize           => $nexenta_blocksize,
    nexenta_sparse              => $nexenta_sparse,
    nexenta_rest_port           => $nexenta_rest_port,
    volume_driver               => $volume_driver,
    extra_options               => $extra_options,
  }
}
