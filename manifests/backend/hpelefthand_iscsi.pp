# Configures Cinder volume HPE lefthand ISCSI driver.
# Parameters are particular to each volume driver.
#
# === Parameters
#
# [*hpelefthand_api_url*]
#   (required) url for api access to lefthand - example https://10.x.x.x:8080/api/v1
#
# [*hpelefthand_username*]
#   (required) Username for HPElefthand admin user
#
# [*hpelefthand_password*]
#   (required) Password for hpelefthand_username
#
# [*volume_backend_name*]
#   (optional) Allows for the volume_backend_name to be separate of $name.
#   Defaults to: $name
#
# [*volume_driver*]
#   (optional) Setup cinder-volume to use HPE LeftHand volume driver.
#   Defaults to 'cinder.volume.drivers.hpe.hpe_lefthand_iscsi.HPELeftHandISCSIDriver'
#
# [*hpelefthand_iscsi_chap_enabled*]
#   (required) setting to false by default
#
# [*hpelefthand_clustername*]
#   (required) clustername of hpelefthand
#
# [*hpelefthand_debug*]
#   (required) setting to false by default
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
#     { 'hpelefthand_iscsi_backend/param1' => { 'value' => value1 } }
#
define cinder::backend::hpelefthand_iscsi(
  $hpelefthand_api_url,
  $hpelefthand_username,
  $hpelefthand_password,
  $hpelefthand_clustername,
  $volume_backend_name            = $name,
  $volume_driver                  = 'cinder.volume.drivers.hpe.hpe_lefthand_iscsi.HPELeftHandISCSIDriver',
  $hpelefthand_iscsi_chap_enabled = false,
  $hpelefthand_debug              = false,
  $manage_volume_type             = false,
  $extra_options                  = {},
) {

  include ::cinder::deps

  cinder_config {
    "${name}/volume_backend_name":            value => $volume_backend_name;
    "${name}/volume_driver":                  value => $volume_driver;
    "${name}/hpelefthand_username":           value => $hpelefthand_username;
    "${name}/hpelefthand_password":           value => $hpelefthand_password, secret => true;
    "${name}/hpelefthand_clustername":        value => $hpelefthand_clustername;
    "${name}/hpelefthand_api_url":            value => $hpelefthand_api_url;
    "${name}/hpelefthand_iscsi_chap_enabled": value => $hpelefthand_iscsi_chap_enabled;
    "${name}/hpelefthand_debug":              value => $hpelefthand_debug;
  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => ["volume_backend_name=${volume_backend_name}"],
    }
  }

  create_resources('cinder_config', $extra_options)

}
