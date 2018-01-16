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
  $xtremio_array_busy_retry_count    = 5,
  $xtremio_array_busy_retry_interval = 5,
  $xtremio_volumes_per_glance_cache  = 100,
  $manage_volume_type                = false,
  $extra_options                     = {},
) {

  include ::cinder::deps

  $driver = 'emc.xtremio.XtremIOISCSIDriver'
  cinder_config {
    "${name}/volume_backend_name":               value => $volume_backend_name;
    "${name}/volume_driver":                     value => "cinder.volume.drivers.${driver}";
    "${name}/san_ip":                            value => $san_ip;
    "${name}/san_login":                         value => $san_login;
    "${name}/san_password":                      value => $san_password, secret => true;
    "${name}/xtremio_cluster_name":              value => $xtremio_cluster_name;
    "${name}/xtremio_array_busy_retry_count":    value => $xtremio_array_busy_retry_count;
    "${name}/xtremio_array_busy_retry_interval": value => $xtremio_array_busy_retry_interval;
    "${name}/xtremio_volumes_per_glance_cache":  value => $xtremio_volumes_per_glance_cache;

  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => ["volume_backend_name=${volume_backend_name}"],
    }
  }

  create_resources('cinder_config', $extra_options)

}
