# == Class: cinder::backend::vstorage
#
# Configures Cinder to use VStorage volume driver.
#
# === Parameters
#
# [*cluster_name*]
#   (required) Cluster name.
#
# [*cluster_password*]
#   (required) Cluster password.
#
# [*volume_backend_name*]
#   (optional) Allows for the volume_backend_name to be separate of $name.
#   Defaults to: $name
#
# [*shares_config_path*]
#   (optional) Shares config file path.
#   Defaults to: /etc/cinder/vzstorage_shares
#
# [*use_sparsed_volumes*]
#   (optional) Whether or not to use sparsed volumes.
#   Defaults to: $::os_service_default
#
# [*used_ratio*]
#   (optional) Used ratio.
#   Defaults to: $::os_service_default
#
# [*mount_point_base*]
#   (optional) Mount point base path.
#   Defaults to: $::os_service_default
#
# [*default_volume_format*]
#   (optional) Default volume format.
#   Defaults to: $::os_service_default
#
# [*manage_volume_type*]
#   (Optional) Whether or not manage Cinder Volume type.
#   If set to true, a Cinder Volume type will be created
#   with volume_backend_name=$volume_backend_name key/value.
#   Defaults to: false
#
# [*mount_user*]
#   (optional) Mount user.
#   Defaults to: cinder
#
# [*mount_group*]
#   (optional) Mount group.
#   Defaults to: root
#
# [*mount_permissions*]
#   (optional) Mount permissions.
#   Defaults to: 0770
#
# [*manage_package*]
#   (optional) Ensures VStorage client package is installed if true.
#   Defaults to: true
#
define cinder::backend::vstorage (
  $cluster_name,
  $cluster_password,
  $volume_backend_name   = $name,
  $shares_config_path    = '/etc/cinder/vzstorage_shares',
  $use_sparsed_volumes   = $::os_service_default,
  $used_ratio            = $::os_service_default,
  $mount_point_base      = $::os_service_default,
  $default_volume_format = $::os_service_default,
  $manage_volume_type    = false,
  $mount_user            = 'cinder',
  $mount_group           = 'root',
  $mount_permissions     = '0770',
  $manage_package        = true,
) {

  include ::cinder::deps

  cinder_config {
    "${name}/volume_backend_name":             value => $volume_backend_name;
    "${name}/volume_driver":                   value => 'cinder.volume.drivers.vzstorage.VZStorageDriver';
    "${name}/vzstorage_shares_config":         value => $shares_config_path;
    "${name}/vzstorage_sparsed_volumes":       value => $use_sparsed_volumes;
    "${name}/vzstorage_used_ratio":            value => $used_ratio;
    "${name}/vzstorage_mount_point_base":      value => $mount_point_base;
    "${name}/vzstorage_default_volume_format": value => $default_volume_format;
  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => ['vz:volume_format=qcow2'],
    }
    cinder_type { "${volume_backend_name}-ploop":
      ensure     => present,
      properties => ['vz:volume_format=ploop'],
    }
  }

  if $manage_package {
    package { 'vstorage-client':
      ensure => present,
      tag    => 'cinder-support-package',
    }
  }

  $mount_opts = ['-u', $mount_user, '-g', $mount_group, '-m', $mount_permissions]

  file { $shares_config_path:
    content => inline_template("${cluster_name}:${cluster_password} <%= @mount_opts %>"),
    owner   => 'root',
    group   => 'cinder',
    mode    => '0640',
    require => Anchor['cinder::install::end'],
    notify  => Anchor['cinder::service::begin'],
  }

}
