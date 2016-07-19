# == Class: cinder::volume::hpe3par
#
# Configures Cinder volume HPE 3par driver.
# Parameters are particular to each volume driver.
#
# === Parameters
#
# [*volume_driver*]
#   (optional) Setup cinder-volume to use HPE 3par volume driver.
#   Defaults to 'cinder.volume.drivers.hpe.hpe_3par_fc.HPE3PARFCDriver'
#
# [*san_ip*]
#   (required) IP address of HPE 3par service processor.
#
# [*san_login*]
#   (required) Username for HPE 3par account.
#
# [*san_password*]
#   (required) Password for HPE 3par account.
#
# [*hpe3par_api_url*]
#   (required) url for api access to 3par - expample
#   https://10.x.x.x:8080/api/v1
#
# [*hpe3par_username*]
#   (required) Username for HPE3par admin user
#
# [*hpe3par_password*]
#   (required) Password for hpe3par_username
#
# [*hpe3par_iscsi_ips*]
#   (required) iscsi ip addresses for the HPE 3par array
#
# [*hpe3par_iscsi_chap_enabled*]
#   (required) setting to false by default
#
# [*hpe3par_cpg_snap*]
#   (optional) set to hpe3par_cfg by default in the cinder driver
#
# [*hpe3par_snapshot_retention*]
#   (required) setting to 48 hours as default expiration - ensures snapshot
#   cannot be deleted prior to expiration
#
# [*hpe3par_snapshot_expiration*]
#   (required) setting to 72 hours as default (must be larger than retention)
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend stanza
#   Defaults to: {}
#   Example :
#     { 'h3par_iscsi_backend/param1' => { 'value' => value1 } }
#
class cinder::volume::hpe3par_iscsi(
  $hpe3par_api_url,
  $hpe3par_username,
  $hpe3par_password,
  $hpe3par_iscsi_ips,
  $san_ip,
  $san_login,
  $san_password,
  $volume_driver               = 'cinder.volume.drivers.hpe.hpe_3par_iscsi.HPE3PARISCSIDriver',
  $hpe3par_iscsi_chap_enabled  = false,
  $hpe3par_cpg_snap            = 'userCPG',
  $hpe3par_snapshot_retention  = 48,
  $hpe3par_snapshot_expiration = 72,
  $extra_options               = {},
) {

  include ::cinder::deps

  warning('Usage of cinder::volume::hpe3par_iscsi is deprecated, please use
cinder::backend::hpe3par_iscsi instead.')

  cinder::backend::hpe3par_iscsi { 'DEFAULT':
    volume_driver               => $volume_driver,
    hpe3par_username            => $hpe3par_username,
    hpe3par_password            => $hpe3par_password,
    san_ip                      => $san_ip,
    san_login                   => $san_login,
    san_password                => $san_password,
    hpe3par_iscsi_ips           => $hpe3par_iscsi_ips,
    hpe3par_api_url             => $hpe3par_api_url,
    hpe3par_cpg_snap            => $hpe3par_cpg_snap,
    hpe3par_snapshot_retention  => $hpe3par_snapshot_retention,
    hpe3par_snapshot_expiration => $hpe3par_snapshot_expiration,
    extra_options               => $extra_options,
  }
}
