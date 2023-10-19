# == define: cinder::backend::dellemc_xtremio
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
#   Defaults to $facts['os_service_default'].
#
# [*reserved_percentage*]
#   (Optional) The percentage of backend capacity is reserved.
#   Defaults to $facts['os_service_default'].
#
# [*xtremio_array_busy_retry_count*]
#   (optional) Number of retries in case array is busy.
#   Defaults to $facts['os_service_default']
#
# [*xtremio_array_busy_retry_interval*]
#   (optional) Interval between retries in case array is busy.
#   Defaults to $facts['os_service_default']
#
# [*xtremio_volumes_per_glance_cache*]
#   (optional) Number of volumes created from each cached glance image.
#   Defaults to $facts['os_service_default']
#
# [*xtremio_ports*]
#   (optional) Allowed ports. Comma separated list of XtremIO iSCSI IPs or
#   FC WWNs (ex. 58:cc:f0:98:49:22:07:02) to be used. If is not set all ports
#   are allowed.
#   Defaults to $facts['os_service_default']
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend stanza.
#   Defaults to: {}
#   Example:
#     { 'dellemc_xtremio_backend/param1' => { 'value' => value1 } }
#
# [*manage_volume_type*]
#   (Optional) Whether or not manage Cinder Volume type.
#   If set to true, a Cinder Volume type will be created
#   with volume_backend_name=$volume_backend_name key/value.
#   Defaults to false.
#
# [*xtremio_storage_protocol*]
#   (optional) The Storage protocol, iSCSI or FC.
#   This will determine
#   which Volume Driver will be configured; XtremIOISCSIDriver or XtremIOFCDriver.
#   Defaults to 'iSCSI'
#
define cinder::backend::dellemc_xtremio (
  $san_ip,
  $san_login,
  $san_password,
  $xtremio_cluster_name,
  $volume_backend_name                          = $name,
  $backend_availability_zone                    = $facts['os_service_default'],
  $reserved_percentage                          = $facts['os_service_default'],
  $xtremio_array_busy_retry_count               = $facts['os_service_default'],
  $xtremio_array_busy_retry_interval            = $facts['os_service_default'],
  $xtremio_volumes_per_glance_cache             = $facts['os_service_default'],
  Boolean $manage_volume_type                   = false,
  Enum['iSCSI', 'FC'] $xtremio_storage_protocol = 'iSCSI',
  $xtremio_ports                                = $facts['os_service_default'],
  Hash $extra_options                           = {},
) {

  include cinder::deps

  $driver = $xtremio_storage_protocol ? {
    'FC'    => 'dell_emc.xtremio.XtremIOFCDriver',
    default => 'dell_emc.xtremio.XtremIOISCSIDriver',
  }

  cinder_config {
    "${name}/volume_backend_name":               value => $volume_backend_name;
    "${name}/backend_availability_zone":         value => $backend_availability_zone;
    "${name}/reserved_percentage":               value => $reserved_percentage;
    "${name}/volume_driver":                     value => "cinder.volume.drivers.${driver}";
    "${name}/san_ip":                            value => $san_ip;
    "${name}/san_login":                         value => $san_login;
    "${name}/san_password":                      value => $san_password, secret => true;
    "${name}/xtremio_cluster_name":              value => $xtremio_cluster_name;
    "${name}/xtremio_array_busy_retry_count":    value => $xtremio_array_busy_retry_count;
    "${name}/xtremio_array_busy_retry_interval": value => $xtremio_array_busy_retry_interval;
    "${name}/xtremio_volumes_per_glance_cache":  value => $xtremio_volumes_per_glance_cache;
    "${name}/xtremio_ports":                     value => join(any2array($xtremio_ports), ',');
  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => ["volume_backend_name=${volume_backend_name}"],
    }
  }

  create_resources('cinder_config', $extra_options)

}
