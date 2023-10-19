#
# Define: cinder::backend::iscsi
#
# === Parameters:
#
# [*target_ip_address*]
#   (Optional) The IP address that the iSCSI daemon is listening on.
#   Defaults to $facts['os_service_default'].
#
# [*volume_backend_name*]
#   (Optional) Allows for the volume_backend_name to be separate of $name.
#   Defaults to: $name
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
# [*volume_driver*]
#   (Optional) Driver to use for volume creation
#   Defaults to 'cinder.volume.drivers.lvm.LVMVolumeDriver'.
#
# [*volume_group*]
#   (Optional) Name for the VG that will contain exported volumes
#   Defaults to $facts['os_service_default']
#
# [*volumes_dir*]
#   (Optional) Volume configuration file storage directory
#   Defaults to '/var/lib/cinder/volumes'.
#
# [*target_helper*]
#   (Optional) iSCSI target user-land tool to use.
#   Defaults to $::cinder::params::target_helper.
#
# [*target_protocol*]
#   (Optional) Protocol to use as iSCSI driver
#   Defaults to $facts['os_service_default'].
#
# [*manage_volume_type*]
#   (Optional) Whether or not manage Cinder Volume type.
#   If set to true, a Cinder Volume type will be created
#   with volume_backend_name=$volume_backend_name key/value.
#   Defaults to false.
#
# [*extra_options*]
#   (Optional) Hash of extra options to pass to the backend stanza
#   Defaults to: {}
#   Example :
#     { 'iscsi_backend/param1' => { 'value' => value1 } }
#
define cinder::backend::iscsi (
  $target_ip_address          = $facts['os_service_default'],
  $volume_backend_name        = $name,
  $backend_availability_zone  = $facts['os_service_default'],
  $reserved_percentage        = $facts['os_service_default'],
  $volume_driver              = 'cinder.volume.drivers.lvm.LVMVolumeDriver',
  $volume_group               = $facts['os_service_default'],
  $volumes_dir                = '/var/lib/cinder/volumes',
  $target_helper              = undef,
  $target_protocol            = $facts['os_service_default'],
  Boolean $manage_volume_type = false,
  Hash $extra_options         = {},
) {

  include cinder::deps
  include cinder::params

  $target_helper_real = $target_helper ? {
    undef   => $::cinder::params::target_helper,
    default => $target_helper,
  }

  # NOTE(mnaser): Cinder requires /usr/sbin/thin_check to create volumes which
  #               does not get installed with Cinder (see LP#1615134).
  if $facts['os']['family'] == 'Debian' {
    ensure_packages( 'thin-provisioning-tools', {
      ensure => present,
      tag    => 'cinder-support-package',
    })
  }

  cinder_config {
    "${name}/volume_backend_name":        value => $volume_backend_name;
    "${name}/backend_availability_zone":  value => $backend_availability_zone;
    "${name}/reserved_percentage":        value => $reserved_percentage;
    "${name}/volume_driver":              value => $volume_driver;
    "${name}/target_ip_address":          value => $target_ip_address;
    "${name}/target_helper":              value => $target_helper_real;
    "${name}/volume_group":               value => $volume_group;
    "${name}/volumes_dir":                value => $volumes_dir;
    "${name}/target_protocol":            value => $target_protocol;
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
        'ensure' => present,
        'name'   => $::cinder::params::tgt_package_name,
        'tag'    => 'cinder-support-package',
      })

      ensure_resource('file_line', "cinder include ${volumes_dir}", {
        'path'    => '/etc/tgt/targets.conf',
        'line'    => "include ${volumes_dir}/*",
        'match'   => '#?include /',
        'require' => Anchor['cinder::install::end'],
        'notify'  => Anchor['cinder::service::begin'],
      })

      ensure_resource('service', 'tgtd', {
        'ensure' => running,
        'name'   => $::cinder::params::tgt_service_name,
        'enable' => true,
        'tag'    => 'cinder-support-service',
      })
    }

    'lioadm': {
      ensure_resource('service', 'target', {
        'ensure' => running,
        'enable' => true,
        'tag'    => 'cinder-support-service',
      })

      ensure_packages('targetcli', {
        'ensure' => present,
        'name'   => $::cinder::params::lio_package_name,
        'tag'    => 'cinder-support-package',
      })
    }

    default: {
      fail("Unsupported target helper: ${target_helper_real}.")
    }
  }

}
