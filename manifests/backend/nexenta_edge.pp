# == Class: cinder::backend::nexenta_edge
#
# Setups Cinder with Nexenta Edge volume driver.
#
# === Parameters
#
# [*nexenta_rest_user*]
#   (required) User name to connect to Nexenta Edge.
#
# [*nexenta_rest_password*]
#   (required) Password to connect to Nexenta Edge.
#
# [*nexenta_rest_address*]
#   (required) IP address of Nexenta Edge.
#
# [*nexenta_client_address*]
#   (required) iSCSI Gateway client.
#
# [*nexenta_rest_port*]
#   (optional) HTTP port of Nexenta Edge.
#   Defaults to '8080'.
#
# [*volume_backend_name*]
#   (optional) Allows for the volume_backend_name to be separate of $name.
#   Defaults to: $name
#
# [*nexenta_lun_container*]
#   (optional) Logical path of bucket for LUNs.
#   Defaults to 'cinder'.
#
# [*nexenta_iscsi_service*]
#   (optional) iSCSI service name.
#   Defaults to 'cinder'.
#
# [*nexenta_chunksize*]
#   (optional) Chunk size for volumes.
#   Defaults to '32768'.
#
# [*volume_driver*]
#   (required) Nexenta driver to use.
#   Defaults to: 'cinder.volume.drivers.nexenta.nexentaedge.iscsi.NexentaEdgeISCSIDriver'.
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
#     { 'nexenta_backend/param1' => { 'value' => value1 } }
#
define cinder::backend::nexenta_edge (
  $nexenta_rest_user,
  $nexenta_rest_password,
  $nexenta_rest_address,
  $nexenta_client_address,
  $nexenta_rest_port      = '8080',
  $volume_backend_name    = $name,
  $nexenta_lun_container  = 'cinder',
  $nexenta_iscsi_service  = 'cinder',
  $nexenta_chunksize      = '32768',
  $volume_driver          = 'cinder.volume.drivers.nexenta.nexentaedge.iscsi.NexentaEdgeISCSIDriver',
  $manage_volume_type     = false,
  $extra_options          = {},
) {

  cinder_config {
    "${name}/volume_backend_name":    value => $volume_backend_name;
    "${name}/nexenta_rest_user":      value => $nexenta_rest_user;
    "${name}/nexenta_rest_password":  value => $nexenta_rest_password, secret => true;
    "${name}/nexenta_rest_address":   value => $nexenta_rest_address;
    "${name}/nexenta_client_address": value => $nexenta_client_address;
    "${name}/nexenta_rest_port":      value => $nexenta_rest_port;
    "${name}/nexenta_lun_container":  value => $nexenta_lun_container;
    "${name}/nexenta_iscsi_service":  value => $nexenta_iscsi_service;
    "${name}/nexenta_chunksize":      value => $nexenta_chunksize;
    "${name}/volume_driver":          value => $volume_driver;
  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => ["volume_backend_name=${volume_backend_name}"],
    }
  }

  create_resources('cinder_config', $extra_options)

}
