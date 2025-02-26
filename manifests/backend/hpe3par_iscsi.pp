# Configures Cinder volume HPE 3par ISCSI driver.
# Parameters are particular to each volume driver.
#
# === Parameters
#
# [*hpe3par_api_url*]
#    (required) url for api access to 3par - example
#    https://10.x.x.x:8080/api/v1
#
# [*hpe3par_username*]
#    (required) Username for hpe3par admin user
#
# [*hpe3par_password*]
#    (required) Password for hpe3par_username
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
# [*hpe3par_iscsi_ips*]
#   (required) iscsi IP addresses for the HPE 3par array
#   This is a list of IPs with ports in a string, for example:
#   '1.2.3.4:3261, 5.6.7.8:3261'
#
# [*volume_backend_name*]
#   (optional) Allows for the volume_backend_name to be separate of $name.
#   Defaults to: $name
#
# [*backend_availability_zone*]
#   (Optional) Availability zone for this volume backend.
#   If not set, the storage_availability_zone option value
#   is used as the default for all backends.
#   Defaults to $facts['os_service_default'].
#
# [*image_volume_cache_enabled*]
#   (Optional) Enable Cinder's image cache function for this backend.
#   Defaults to $facts['os_service_default'],
#
# [*image_volume_cache_max_size_gb*]
#   (Optional) Max size of the image volume cache for this backend in GB.
#   Defaults to $facts['os_service_default'],
#
# [*image_volume_cache_max_count*]
#   (Optional) Max number of entries allowed in the image volume cache.
#   Defaults to $facts['os_service_default'],
#
# [*reserved_percentage*]
#   (Optional) The percentage of backend capacity is reserved.
#   Defaults to $facts['os_service_default'].
#
# [*max_over_subscription_ratio*]
#   (optional) Representation of the over subscription ratio when thin
#   provisionig is involved.
#   Defaults to $facts['os_service_default'].
#
# [*volume_driver*]
#   (optional) Setup cinder-volume to use HPE 3par volume driver.
#   Defaults to 'cinder.volume.drivers.hpe.hpe_3par_iscsi.HPE3PARISCSIDriver'.
#
# [*hpe3par_iscsi_chap_enabled*]
#   (optional) setting to false by default
#   Defaults to $facts['os_service_default'].
#
# [*hpe3par_cpg_snap*]
#   (optional) set to hpe3par_cfg by default in the cinder driver
#   Defaults to $facts['os_service_default'].
#
# [*hpe3par_snapshot_retention*]
#   (required) Time in hours for snapshot retention. Must be less
#   than hpe3par_snapshot_expiration.
#   Defaults to 48.
#
# [*hpe3par_snapshot_expiration*]
#   (required) Time in hours until a snapshot expires. Must be more
#   than hpe3par_snapshot_retention.
#   Defaults to 72.
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
#     { 'h3par_iscsi_backend/param1' => { 'value' => value1 } }
#
define cinder::backend::hpe3par_iscsi(
  $hpe3par_api_url,
  $hpe3par_username,
  $hpe3par_password,
  $san_ip,
  $san_login,
  $san_password,
  $hpe3par_iscsi_ips,
  $volume_backend_name            = $name,
  $backend_availability_zone      = $facts['os_service_default'],
  $image_volume_cache_enabled     = $facts['os_service_default'],
  $image_volume_cache_max_size_gb = $facts['os_service_default'],
  $image_volume_cache_max_count   = $facts['os_service_default'],
  $reserved_percentage            = $facts['os_service_default'],
  $max_over_subscription_ratio    = $facts['os_service_default'],
  $volume_driver                  = 'cinder.volume.drivers.hpe.hpe_3par_iscsi.HPE3PARISCSIDriver',
  $hpe3par_iscsi_chap_enabled     = $facts['os_service_default'],
  $hpe3par_cpg_snap               = $facts['os_service_default'],
  $hpe3par_snapshot_retention     = 48,
  $hpe3par_snapshot_expiration    = 72,
  Boolean $manage_volume_type     = false,
  Hash $extra_options             = {},
) {

  include cinder::deps

  if ($hpe3par_snapshot_expiration <= $hpe3par_snapshot_retention) {
    fail ('hpe3par_snapshot_expiration must be greater than hpe3par_snapshot_retention')
  }

  cinder_config {
    "${name}/volume_backend_name":            value => $volume_backend_name;
    "${name}/backend_availability_zone":      value => $backend_availability_zone;
    "${name}/image_volume_cache_enabled":     value => $image_volume_cache_enabled;
    "${name}/image_volume_cache_max_size_gb": value => $image_volume_cache_max_size_gb;
    "${name}/image_volume_cache_max_count":   value => $image_volume_cache_max_count;
    "${name}/reserved_percentage":            value => $reserved_percentage;
    "${name}/max_over_subscription_ratio":    value => $max_over_subscription_ratio;
    "${name}/volume_driver":                  value => $volume_driver;
    "${name}/hpe3par_username":               value => $hpe3par_username;
    "${name}/hpe3par_password":               value => $hpe3par_password, secret => true;
    "${name}/san_ip":                         value => $san_ip;
    "${name}/san_login":                      value => $san_login;
    "${name}/san_password":                   value => $san_password, secret => true;
    "${name}/hpe3par_iscsi_ips":              value => $hpe3par_iscsi_ips;
    "${name}/hpe3par_api_url":                value => $hpe3par_api_url;
    "${name}/hpe3par_iscsi_chap_enabled":     value => $hpe3par_iscsi_chap_enabled;
    "${name}/hpe3par_cpg_snap":               value => $hpe3par_cpg_snap;
    "${name}/hpe3par_snapshot_retention":     value => $hpe3par_snapshot_retention;
    "${name}/hpe3par_snapshot_expiration":    value => $hpe3par_snapshot_expiration;
  }

  # TODO(tkajinam): Remove this after 2025.1 release
  cinder_config {
    "${name}/hpe3par_snap_cpg": ensure => absent;
  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => {'volume_backend_name' => $volume_backend_name},
    }
  }

  create_resources('cinder_config', $extra_options)

}
