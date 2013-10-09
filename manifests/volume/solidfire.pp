# == Class: cinder::volume::solidfire
#
# Configures Cinder volume SolidFire driver.
# Parameters are particular to each volume driver.
#
# === Parameters
#
# [*volume_driver*]
#   (optional) Setup cinder-volume to use SolidFire volume driver.
#   Defaults to 'cinder.volume.drivers.solidfire.SolidFire'
#
# [*san_ip*]
#   (required) IP address of SolidFire clusters MVIP.
#
# [*san_login*]
#   (required) Username for SolidFire admin account.
#
# [*san_password*]
#   (required) Password for SolidFire admin account.
#
# [*sf_emulate_512*]
#   (optional) Use 512 byte emulation for volumes.
#   Defaults to True
#
# [*sf_allow_tenant_qos*]
#   (optional) Allow tenants to specify QoS via volume metadata.
#   Defaults to False
#
# [*sf_account_prefix*]
#   (optional) Prefix to use when creating tenant accounts on SolidFire Cluster.
#   Defaults to None, so account name is simply the tenant-uuid
#
# [*sf_api_port*]
#   (optional) Port ID to use to connect to SolidFire API.
#   Defaults to 443
#
class cinder::volume::solidfire(
  $volume_driver       = 'cinder.volume.drivers.solidfire.SolidFire',
  $san_ip,
  $san_login,
  $san_password,
  $sf_emulate_512      = true,
  $sf_allow_tenant_qos = false,
  $sf_account_prefix   = '',
  $sf_api_port         = '443'

) {

  cinder_config {
    'DEFAULT/volume_driver':      value => $volume_driver;
    'DEFAULT/san_ip':             value => $san_ip;
    'DEFAULT/san_login':          value => $san_login;
    'DEFAULT/san_password':       value => $san_password;
    'DEFAULT/sf_emulate_512':     value => $sf_emulate_512;
    'DEFAULT/sf_allow_tenant_qos':value => $sf_allow_tenant_qos;
    'DEFAULT/sf_account_prefix':  value => $sf_account_prefix;
    'DEFAULT/sf_api_port':        value => $sf_api_port;
  }
}
