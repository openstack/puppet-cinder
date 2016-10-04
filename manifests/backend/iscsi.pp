#
# Define: cinder::backend::iscsi
#
# === Parameters:
#
# [*iscsi_ip_address*]
#   (Required) The IP address that the iSCSI daemon is listening on
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
# [*volumes_dir*]
#   (Optional) Volume configuration file storage directory
#   Defaults to '/var/lib/cinder/volumes'.
#
# [*iscsi_helper*]
#   (Optional) iSCSI target user-land tool to use.
#   Defaults to '$::cinder::params::iscsi_helper'.
#
# [*iscsi_protocol*]
#   (Optional) Protocol to use as iSCSI driver
#   Defaults to $::os_service_default.
#
# [*manage_volume_type*]
#   (Optional) Whether or not manage Cinder Volume type.
#   If set to true, a Cinde Volume type will be created
#   with volume_backend_name=$volume_backend_name key/value.
#   Defaults to false.
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend stanza
#   Defaults to: {}
#   Example :
#     { 'iscsi_backend/param1' => { 'value' => value1 } }
#
define cinder::backend::iscsi (
  $iscsi_ip_address,
  $volume_backend_name = $name,
  $volume_driver       = 'cinder.volume.drivers.lvm.LVMVolumeDriver',
  $volume_group        = $::os_service_default,
  $volumes_dir         = '/var/lib/cinder/volumes',
  $iscsi_helper        = $::cinder::params::iscsi_helper,
  $iscsi_protocol      = $::os_service_default,
  $manage_volume_type  = false,
  $extra_options       = {},
) {

  include ::cinder::deps
  include ::cinder::params

  cinder_config {
    "${name}/volume_backend_name":  value => $volume_backend_name;
    "${name}/volume_driver":        value => $volume_driver;
    "${name}/iscsi_ip_address":     value => $iscsi_ip_address;
    "${name}/iscsi_helper":         value => $iscsi_helper;
    "${name}/volume_group":         value => $volume_group;
    "${name}/volumes_dir":          value => $volumes_dir;
    "${name}/iscsi_protocol":       value => $iscsi_protocol;
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
      package { 'tgt':
        ensure => present,
        name   => $::cinder::params::tgt_package_name,
        tag    => 'cinder-support-package',
      }

      if($::osfamily == 'RedHat') {
        file_line { 'cinder include':
          path    => '/etc/tgt/targets.conf',
          line    => "include ${volumes_dir}/*",
          match   => '#?include /',
          require => Anchor['cinder::install::end'],
          notify  => Anchor['cinder::service::begin'],
        }
      }

      service { 'tgtd':
        ensure => running,
        name   => $::cinder::params::tgt_service_name,
        enable => true,
        tag    => 'cinder-support-service',
      }
    }

    'lioadm': {
      service { 'target':
        ensure => running,
        enable => true,
        tag    => 'cinder-support-service',
      }

      package { 'targetcli':
        ensure => present,
        name   => $::cinder::params::lio_package_name,
        tag    => 'cinder-support-package',
      }
    }

    default: {
      fail("Unsupported iscsi helper: ${iscsi_helper}.")
    }
  }

}
