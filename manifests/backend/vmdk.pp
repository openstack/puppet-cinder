# == define: cinder::backend::vmdk
#
# DEPRECATED !!
# Configure the VMware VMDK driver for cinder.
#
# === Parameters
#
# [*host_ip*]
#   The IP address of the VMware vCenter server.
#
# [*host_username*]
#   The username for connection to VMware vCenter server.
#
# [*host_password*]
#   The password for connection to VMware vCenter server.
#
# [*volume_backend_name*]
#   Used to set the volume_backend_name in multiple backends.
#   Defaults to $name as passed in the title.
#
# [*backend_availability_zone*]
#   (Optional) Availability zone for this volume backend.
#   If not set, the storage_availability_zone option value
#   is used as the default for all backends.
#   Defaults to $facts['os_service_default'].
#
# [*api_retry_count*]
#   (optional) The number of times we retry on failures,
#   e.g., socket error, etc.
#   Defaults to $facts['os_service_default'].
#
# [*volume_folder*]
#   (optional) The name for the folder in the VC datacenter that will contain
#   cinder volumes.
#   Defaults to $facts['os_service_default'].
#
# [*max_object_retrieval*]
#   (optional) The maximum number of ObjectContent data objects that should
#   be returned in a single result. A positive value will cause
#   the operation to suspend the retrieval when the count of
#   objects reaches the specified maximum. The server may still
#   limit the count to something less than the configured value.
#   Any remaining objects may be retrieved with additional requests.
#   Defaults to $facts['os_service_default']
#
# [*task_poll_interval*]
#   (optional) The interval in seconds used for polling of remote tasks.
#   Defaults to $facts['os_service_default'].
#
# [*image_transfer_timeout_secs*]
#   (optional) The timeout in seconds for VMDK volume transfer between Cinder
#   and Glance.
#   Defaults to $facts['os_service_default']
#
# [*wsdl_location*]
#   (optional) VIM Service WSDL Location e.g
#   http://<server>/vimService.wsdl. Optional over-ride to
#   default location for bug work-arounds.
#   Defaults to $facts['os_service_default'].
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
#     { 'vmdk_backend/param1' => { 'value' => value1 } }
#
define cinder::backend::vmdk (
  $host_ip,
  $host_username,
  $host_password,
  $volume_backend_name         = $name,
  $backend_availability_zone   = $facts['os_service_default'],
  $volume_folder               = $facts['os_service_default'],
  $api_retry_count             = $facts['os_service_default'],
  $max_object_retrieval        = $facts['os_service_default'],
  $task_poll_interval          = $facts['os_service_default'],
  $image_transfer_timeout_secs = $facts['os_service_default'],
  $wsdl_location               = $facts['os_service_default'],
  Boolean $manage_volume_type  = false,
  Hash $extra_options          = {},
) {

  include cinder::deps

  warning('Support for VMWare storage driver has been deprecated')

  cinder_config {
    "${name}/volume_backend_name":                value => $volume_backend_name;
    "${name}/backend_availability_zone":          value => $backend_availability_zone;
    "${name}/volume_driver":                      value => 'cinder.volume.drivers.vmware.vmdk.VMwareVcVmdkDriver';
    "${name}/vmware_host_ip":                     value => $host_ip;
    "${name}/vmware_host_username":               value => $host_username;
    "${name}/vmware_host_password":               value => $host_password, secret => true;
    "${name}/vmware_volume_folder":               value => $volume_folder;
    "${name}/vmware_api_retry_count":             value => $api_retry_count;
    "${name}/vmware_max_object_retrieval":        value => $max_object_retrieval;
    "${name}/vmware_task_poll_interval":          value => $task_poll_interval;
    "${name}/vmware_image_transfer_timeout_secs": value => $image_transfer_timeout_secs;
    "${name}/vmware_wsdl_location":               value => $wsdl_location;
    "${name}/host":                               value => "vmdk:${host_ip}-${volume_folder}";
  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => ["volume_backend_name=${volume_backend_name}"],
    }
  }

  create_resources('cinder_config', $extra_options)

}
