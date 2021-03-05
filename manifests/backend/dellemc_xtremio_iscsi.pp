# == define: cinder::backend::dellemc_xtremio_iscsi
#
# Configure the Dell EMC XtremIO Driver for cinder.
#
# === Parameters
#
# [*san_ip*]
#   (required) IP address of XMS.
#
# [*san_login*]
#   (required) XMS user name.
#
# [*san_password*]
#   (required) XMS user password.
#
# [*xtremio_cluster_name*]
#   (required) XMS cluster id in multi-cluster environment.
#
# [*volume_backend_name*]
#   (optional) The storage backend name.
#   Defaults to the name of the backend
#
# [*backend_availability_zone*]
#   (Optional) Availability zone for this volume backend.
#   If not set, the storage_availability_zone option value
#   is used as the default for all backends.
#   Defaults to $::os_service_default.
#
# [*xtremio_array_busy_retry_count*]
#   (optional) Number of retries in case array is busy.
#   Defaults to 5
#
# [*xtremio_array_busy_retry_interval*]
#   (optional) Interval between retries in case array is busy.
#   Defaults to 5
#
# [*xtremio_volumes_per_glance_cache*]
#   (optional) Number of volumes created from each cached glance image.
#   Defaults to 100
#
# [*xtremio_ports*]
#   (optional) Allowed ports. Comma separated list of XtremIO iSCSI IPs or
#   FC WWNs (ex. 58:cc:f0:98:49:22:07:02) to be used. If is not set all ports
#   are allowed.
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend stanza.
#   Defaults to: {}
#   Example:
#     { 'dellemc_xtremio_iscsi_backend/param1' => { 'value' => value1 } }
#
# [*manage_volume_type*]
#   (Optional) Whether or not manage Cinder Volume type.
#   If set to true, a Cinder Volume type will be created
#   with volume_backend_name=$volume_backend_name key/value.
#   Defaults to false.
#
define cinder::backend::dellemc_xtremio_iscsi (
  $san_ip,
  $san_login,
  $san_password,
  $xtremio_cluster_name,
  $volume_backend_name               = $name,
  $backend_availability_zone         = $::os_service_default,
  $xtremio_array_busy_retry_count    = 5,
  $xtremio_array_busy_retry_interval = 5,
  $xtremio_volumes_per_glance_cache  = 100,
  $manage_volume_type                = false,
  $xtremio_ports                     = $::os_service_default,
  $extra_options                     = {},
) {

  include cinder::deps

  warning('The cinder::backend::dellemc_xtremio_iscsi is deprecated and will be removed in V-release, \
please use cinder::backend::dellemc_xtremio resource instead.')

  $driver = 'dell_emc.xtremio.XtremIOISCSIDriver'
  cinder_config {
    "${name}/volume_backend_name":               value => $volume_backend_name;
    "${name}/backend_availability_zone":         value => $backend_availability_zone;
    "${name}/volume_driver":                     value => "cinder.volume.drivers.${driver}";
    "${name}/san_ip":                            value => $san_ip;
    "${name}/san_login":                         value => $san_login;
    "${name}/san_password":                      value => $san_password, secret => true;
    "${name}/xtremio_cluster_name":              value => $xtremio_cluster_name;
    "${name}/xtremio_array_busy_retry_count":    value => $xtremio_array_busy_retry_count;
    "${name}/xtremio_array_busy_retry_interval": value => $xtremio_array_busy_retry_interval;
    "${name}/xtremio_volumes_per_glance_cache":  value => $xtremio_volumes_per_glance_cache;
    "${name}/xtremio_ports":                     value => $xtremio_ports;

  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => ["volume_backend_name=${volume_backend_name}"],
    }
  }

  create_resources('cinder_config', $extra_options)

}
