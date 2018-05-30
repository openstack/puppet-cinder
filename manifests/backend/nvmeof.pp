#
# Define: cinder::backend::nvmeof
#
# === Parameters:
#
# [*target_ip_address*]
#   (Required) The IP address of NVMe target.
#
# [*target_port*]
#   (Required) Port that NVMe target is listening on.
#
# [*target_helper*]
#   (Required) Target user-land tool to use.
#
# [*target_protocol*]
#   (Required) Target rotocol to use.
#
# [*target_prefix*]
#   (Optional) Prefix for LVM volumes.
#   Defaults to '$::os_service_default'.
#
# [*nvmet_port_id*]
#   (Optional) Port id of the NVMe target.
#   Defaults to '1'.
#
# [*nvmet_ns_id*]
#   (Optional) The namespace id associated with the subsystem.
#   Defaults to '10'.
#
# [*volume_backend_name*]
#   (optional) Allows for the volume_backend_name to be separate of $name.
#   Defaults to: $name
#
# [*volume_driver*]
#   (Optional) Driver to use for volume creation
#   Defaults to 'cinder.volume.drivers.lvm.LVMVolumeDriver'.
#
# [*volume_group*]
#   (Optional) Name for the VG that will contain exported volumes
#   Defaults to $::os_service_default
#
define cinder::backend::nvmeof (
  $target_ip_address,
  $target_port,
  $target_helper,
  $target_protocol,
  $target_prefix        = $::os_service_default,
  $nvmet_port_id        = '1',
  $nvmet_ns_id          = '10',
  $volume_backend_name  = $name,
  $volume_driver        = 'cinder.volume.drivers.lvm.LVMVolumeDriver',
  $volume_group         = $::os_service_default,
) {

  include ::cinder::deps
  include ::cinder::params

  cinder_config {
    "${name}/target_ip_address":    value => $target_ip_address;
    "${name}/target_port":          value => $target_port;
    "${name}/target_helper":        value => $target_helper;
    "${name}/target_protocol":      value => $target_protocol;
    "${name}/target_prefix":        value => $target_prefix;
    "${name}/nvmet_port_id":        value => $nvmet_port_id;
    "${name}/nvmet_ns_id":          value => $nvmet_ns_id;
    "${name}/volume_backend_name":  value => $volume_backend_name;
    "${name}/volume_driver":        value => $volume_driver;
    "${name}/volume_group":         value => $volume_group;
  }

  package { 'nvmetcli':
    ensure => present,
    name   => 'nvmetcli',
    tag    => 'cinder-support-package',
  }

  package { 'nvme-cli':
    ensure => present,
    name   => 'nvme-cli',
    tag    => 'cinder-support-package',
  }

}
