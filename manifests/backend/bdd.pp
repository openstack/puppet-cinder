#
# Define: cinder::backend::bdd
#
# This class activate Cinder Block Device driver backend
#
# === Parameters:
#
# [*iscsi_ip_address*]
#   (Required) The IP address that the iSCSI daemon is listening on
#
# [*available_devices*]
#   (Required) List of all available devices. Real hard disks.
#   Should be a string.
#
# [*volume_backend_name*]
#   (optional) Allows for the volume_backend_name to be separate of $name.
#   Defaults to: $name
#
# [*volume_driver*]
#   (Optional) Driver to use for volume creation
#   Defaults to 'cinder.volume.drivers.block_device.BlockDeviceDriver'.
#
# [*volume_group*]
#   (Optional) Name for the VG that will contain exported volumes
#   Defaults to $::os_service_default
#
# [*volumes_dir*]
#   (Optional) Volume configuration file storage directory
#   Defaults to '/var/lib/cinder/volumes'.
#
# [*iscsi_helper*]
#   (Optional) iSCSI target user-land tool to use.
#   Defaults to tgtadm.
#
# [*iscsi_protocol*]
#   (Optional) Protocol to use as iSCSI driver
#   Defaults to $::os_service_default.
#
# [*volume_clear*]
#   (Optional) Method used to wipe old volumes
#   Defaults to $::os_service_default.
#
# [*manage_volume_type*]
#   (Optional) Whether or not manage Cinder Volume type.
#   If set to true, a Cinder Volume type will be created
#   with volume_backend_name=$volume_backend_name key/value.
#   Defaults to false.
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend
#   Defaults to: {}
#   Example :
#     { 'bdd_backend/param1' => { 'value' => value1 } }
#
# === Examples
#
#  cinder::backend::bdd { 'myBDDbackend':
#    iscsi_ip_address  => '10.20.0.2',
#    available_devices => '/dev/sda,/dev/sdb'
#  }
#
# === Authors
#
# Denis Egorenko <degorenko@mirantis.com>
#
define cinder::backend::bdd (
  $iscsi_ip_address,
  $available_devices,
  $volume_backend_name = $name,
  $volume_driver       = 'cinder.volume.drivers.block_device.BlockDeviceDriver',
  $volume_group        = $::os_service_default,
  $volumes_dir         = '/var/lib/cinder/volumes',
  $iscsi_helper        = 'tgtadm',
  $iscsi_protocol      = $::os_service_default,
  $volume_clear        = $::os_service_default,
  $manage_volume_type  = false,
  $extra_options       = {},
) {

  include ::cinder::deps
  include ::cinder::params

  if ($volume_driver == 'cinder.volume.drivers.block_device.BlockDeviceDriver') {
    warning('Cinder block device driver is deprecated. Please use LVM backend')
  }


  cinder_config {
    "${name}/available_devices":   value => $available_devices;
    "${name}/volume_backend_name": value => $volume_backend_name;
    "${name}/volume_driver":       value => $volume_driver;
    "${name}/iscsi_ip_address":    value => $iscsi_ip_address;
    "${name}/iscsi_helper":        value => $iscsi_helper;
    "${name}/volume_group":        value => $volume_group;
    "${name}/volumes_dir":         value => $volumes_dir;
    "${name}/iscsi_protocol":      value => $iscsi_protocol;
    "${name}/volume_clear":        value => $volume_clear;
  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => ["volume_backend_name=${volume_backend_name}"],
    }
  }

  create_resources('cinder_config', $extra_options)

  case $iscsi_helper {
    'tgtadm': {
      ensure_packages('tgt', {
        ensure => present,
        name   => $::cinder::params::tgt_package_name,
        tag    => 'cinder-support-package'})

      ensure_resource('service', 'tgtd', {
        ensure => running,
        name   => $::cinder::params::tgt_service_name,
        tag    => 'cinder-support-service'})

      if($::osfamily == 'RedHat') {
        ensure_resource('file_line', 'cinder include', {
          path    => '/etc/tgt/targets.conf',
          line    => "include ${volumes_dir}/*",
          match   => '#?include /',
          require => Anchor['cinder::install::end'],
          notify  => Anchor['cinder::service::begin']})
      }
    }

    'lioadm': {
      ensure_packages('targetcli', {
        ensure => present,
        name   => $::cinder::params::lio_package_name,
        tag    => 'cinder-support-package'})

      ensure_resource('service', 'target', {
        ensure => running,
        enable => true,
        tag    => 'cinder-support-service'})
    }

    default: {
      fail("Unsupported iscsi helper: ${iscsi_helper}.")
    }
  }

}
