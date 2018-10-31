#
# Define: cinder::backend::bdd
#
# This class activate Cinder Block Device driver backend
#
# === Parameters:
#
# [*available_devices*]
#   (Required) List of all available devices. Real hard disks.
#   Should be a string.
#
# [*target_ip_address*]
#   (optional) The IP address that the iSCSI daemon is listening on.
#   If not set, the iscsi_ip_address must be specified. The target_ip_address
#   will be required once the deprecated iscsi_ip_address parameter is
#   removed in a future release.
#   Defaults to undef.
#
# [*volume_backend_name*]
#   (optional) Allows for the volume_backend_name to be separate of $name.
#   Defaults to: $name
#
# [*backend_availability_zone*]
#   (Optional) Availability zone for this volume backend.
#   If not set, the storage_availability_zone option value
#   is used as the default for all backends.
#   Defaults to $::os_service_default.
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
# [*target_helper*]
#   (Optional) iSCSI target user-land tool to use.
#   Defaults to tgtadm.
#
# [*target_protocol*]
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
# DEPRECATED PARAMETERS
#
# [*iscsi_ip_address*]
#   (Optional) The IP address that the iSCSI daemon is listening on
#   Defaults to undef.
#
# [*iscsi_helper*]
#   (Optional) iSCSI target user-land tool to use.
#   Defaults to undef.
#
# [*iscsi_protocol*]
#   (Optional) Protocol to use as iSCSI driver
#   Defaults to undef.
#
# === Authors
#
# Denis Egorenko <degorenko@mirantis.com>
#
define cinder::backend::bdd (
  $available_devices,
  $target_ip_address         = undef,
  $volume_backend_name       = $name,
  $backend_availability_zone = $::os_service_default,
  $volume_driver             = 'cinder.volume.drivers.block_device.BlockDeviceDriver',
  $volume_group              = $::os_service_default,
  $volumes_dir               = '/var/lib/cinder/volumes',
  $target_helper             = 'tgtadm',
  $target_protocol           = $::os_service_default,
  $volume_clear              = $::os_service_default,
  $manage_volume_type        = false,
  $extra_options             = {},
  # DEPRECATED PARAMETERS
  $iscsi_ip_address          = undef,
  $iscsi_helper              = undef,
  $iscsi_protocol            = undef,
) {

  include ::cinder::deps
  include ::cinder::params

  if ($volume_driver == 'cinder.volume.drivers.block_device.BlockDeviceDriver') {
    warning('Cinder block device driver is deprecated. Please use LVM backend')
  }

  if $target_ip_address or $iscsi_ip_address {
    if $iscsi_ip_address {
      warning('The iscsi_ip_address parameter is deprecated, use target_ip_address instead.')
    }
    $target_ip_address_real = pick($target_ip_address, $iscsi_ip_address)
  } else {
    fail('A target_ip_address or iscsi_ip_address must be specified.')
  }

  if $iscsi_helper {
    warning('The iscsi_helper parameter is deprecated, use target_helper instead.')
    $target_helper_real = $iscsi_helper
  } else {
    $target_helper_real = $target_helper
  }

  if $iscsi_protocol {
    warning('The iscsi_protocol parameter is deprecated, use target_protocol instead.')
    $target_protocol_real = $iscsi_protocol
  } else {
    $target_protocol_real = $target_protocol
  }

  cinder_config {
    "${name}/available_devices":         value => $available_devices;
    "${name}/volume_backend_name":       value => $volume_backend_name;
    "${name}/backend_availability_zone": value => $backend_availability_zone;
    "${name}/volume_driver":             value => $volume_driver;
    "${name}/target_ip_address":         value => $target_ip_address_real;
    "${name}/target_helper":             value => $target_helper_real;
    "${name}/volume_group":              value => $volume_group;
    "${name}/volumes_dir":               value => $volumes_dir;
    "${name}/target_protocol":           value => $target_protocol_real;
    "${name}/volume_clear":              value => $volume_clear;
  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => ["volume_backend_name=${volume_backend_name}"],
    }
  }

  create_resources('cinder_config', $extra_options)

  case $target_helper_real {
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
      fail("Unsupported target helper: ${target_helper_real}.")
    }
  }

}
