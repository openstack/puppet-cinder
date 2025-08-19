# == Define: cinder::backend::vstorage
#
# DEPRECATED !!
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
# [*backend_availability_zone*]
#   (Optional) Availability zone for this volume backend.
#   If not set, the storage_availability_zone option value
#   is used as the default for all backends.
#   Defaults to $facts['os_service_default'].
#
# [*shares_config_path*]
#   (optional) Shares config file path.
#   Defaults to: /etc/cinder/vzstorage_shares
#
# [*use_sparsed_volumes*]
#   (optional) Whether or not to use sparsed volumes.
#   Defaults to: $facts['os_service_default']
#
# [*used_ratio*]
#   (optional) Used ratio.
#   Defaults to: $facts['os_service_default']
#
# [*mount_point_base*]
#   (optional) Mount point base path.
#   Defaults to: $facts['os_service_default']
#
# [*default_volume_format*]
#   (optional) Default volume format.
#   Defaults to: $facts['os_service_default']
#
# [*manage_volume_type*]
#   (Optional) Whether or not manage Cinder Volume type.
#   If set to true, a Cinder Volume type will be created
#   with volume_backend_name=$volume_backend_name key/value.
#   Defaults to: false
#
# [*mount_user*]
#   (optional) Mount user.
#   Defaults to: $cinder::params::user
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
  $volume_backend_name                     = $name,
  $backend_availability_zone               = $facts['os_service_default'],
  Stdlib::Absolutepath $shares_config_path = '/etc/cinder/vzstorage_shares',
  $use_sparsed_volumes                     = $facts['os_service_default'],
  $used_ratio                              = $facts['os_service_default'],
  $mount_point_base                        = $facts['os_service_default'],
  $default_volume_format                   = $facts['os_service_default'],
  Boolean $manage_volume_type              = false,
  $mount_user                              = undef,
  $mount_group                             = 'root',
  $mount_permissions                       = '0770',
  Boolean $manage_package                  = true,
) {
  include cinder::deps
  include cinder::params

  warning("Support for VZStorageDriver has been deprecated because the driver \
is now marked unsupported.")

  $mount_user_real = pick($mount_user, $cinder::params::user)

  cinder_config {
    "${name}/volume_backend_name":             value => $volume_backend_name;
    "${name}/backend_availability_zone":       value => $backend_availability_zone;
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
      properties => { 'vz:volume_format' => 'qcow2' },
    }
    cinder_type { "${volume_backend_name}-ploop":
      ensure     => present,
      properties => { 'vz:volume_format' => 'ploop' },
    }
  }

  if $manage_package {
    stdlib::ensure_packages( 'vstorage-client', {
      ensure => present,
      tag    => 'cinder-support-package',
    })
  }

  $mount_opts = ['-u', $mount_user_real, '-g', $mount_group, '-m', $mount_permissions]

  file { $shares_config_path:
    ensure  => 'file',
    content => inline_template("${cluster_name}:${cluster_password} <%= @mount_opts %>"),
    owner   => 'root',
    group   => $cinder::params::group,
    mode    => '0640',
    require => Anchor['cinder::install::end'],
    notify  => Anchor['cinder::service::begin'],
  }
}
