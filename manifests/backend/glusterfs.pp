#
# == Class: cinder::backend::glusterfs
#
# Configures Cinder to use GlusterFS as a volume driver
#
# === Parameters
#
# [*glusterfs_shares*]
#   (required) An array of GlusterFS volume locations.
#   Must be an array even if there is only one volume.
#
# [*volume_backend_name*]
#   (optional) Allows for the volume_backend_name to be separate of $name.
#   Defaults to: $name
#
# [*glusterfs_backup_mount_point*]
#   (optional) Base dir containing mount point for gluster share.
#   Defaults to $::os_service_default
#
# [*glusterfs_backup_share*]
#   (optonal) GlusterFS share in <hostname|ipv4addr|ipv6addr>:<gluster_vol_name>
#   format. Eg: 1.2.3.4:backup_vol
#   Defaults to $::os_service_default
#
# [*glusterfs_sparsed_volumes*]
#   (optional) Whether or not to use sparse (thin) volumes.
#   Defaults to $::os_service_default which uses the driver's default of "true".
#
# [*glusterfs_mount_point_base*]
#   (optional) Where to mount the Gluster volumes.
#   Defaults to $::os_service_default  which uses the driver's default of
#   "$state_path/mnt".
#
# [*glusterfs_shares_config*]
#   (optional) The config file to store the given $glusterfs_shares.
#   Defaults to '/etc/cinder/shares.conf'
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend stanza
#   Defaults to: {}
#   Example :
#     { 'glusterfs_backend/param1' => { 'value' => value1 } }
#
# [*manage_volume_type*]
#   (Optional) Whether or not manage Cinder Volume type.
#   If set to true, a Cinde Volume type will be created
#   with volume_backend_name=$volume_backend_name key/value.
#   Defaults to false.
#
# === Examples
#
# cinder::backend::glusterfs { 'myGluster':
#   glusterfs_shares = ['192.168.1.1:/volumes'],
# }
#
define cinder::backend::glusterfs (
  $glusterfs_shares,
  $volume_backend_name          = $name,
  $glusterfs_backup_mount_point = $::os_service_default,
  $glusterfs_backup_share       = $::os_service_default,
  $glusterfs_sparsed_volumes    = $::os_service_default,
  $glusterfs_mount_point_base   = $::os_service_default,
  $glusterfs_shares_config      = '/etc/cinder/shares.conf',
  $manage_volume_type           = false,
  $extra_options                = {},
) {

  include ::cinder::deps

  $content = join($glusterfs_shares, "\n")

  file { $glusterfs_shares_config:
    content => "${content}\n",
    require => Anchor['cinder::install::end'],
    notify  => Anchor['cinder::service::begin'],
  }

  cinder_config {
    "${name}/volume_backend_name":  value => $volume_backend_name;
    "${name}/volume_driver":        value =>
      'cinder.volume.drivers.glusterfs.GlusterfsDriver';
    "${name}/glusterfs_backup_mount_point": value => $glusterfs_backup_mount_point;
    "${name}/glusterfs_backup_share":     value => $glusterfs_backup_share;
    "${name}/glusterfs_shares_config":    value => $glusterfs_shares_config;
    "${name}/glusterfs_sparsed_volumes":  value => $glusterfs_sparsed_volumes;
    "${name}/glusterfs_mount_point_base": value => $glusterfs_mount_point_base;
  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => ["volume_backend_name=${volume_backend_name}"],
    }
  }

  create_resources('cinder_config', $extra_options)

}
