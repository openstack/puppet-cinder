#
# == Class: cinder::volume::glusterfs
#
# Configures Cinder to use GlusterFS as a volume driver
#
# === Parameters
#
# [*glusterfs_shares*]
#   (required) An array of GlusterFS volume locations.
#   Must be an array even if there is only one volume.
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
#   Defaults to $::os_service_default which uses the driver's default of "$state_path/mnt".
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
# === Examples
#
# class { 'cinder::volume::glusterfs':
#   glusterfs_shares = ['192.168.1.1:/volumes'],
# }
#
class cinder::volume::glusterfs (
  $glusterfs_shares,
  $glusterfs_backup_mount_point = $::os_service_default,
  $glusterfs_backup_share       = $::os_service_default,
  $glusterfs_sparsed_volumes    = $::os_service_default,
  $glusterfs_mount_point_base   = $::os_service_default,
  $glusterfs_shares_config      = '/etc/cinder/shares.conf',
  $extra_options                = {},
) {

  include ::cinder::deps

  warning('Usage of cinder::volume::glusterfs is deprecated, please use
cinder::backend::glusterfs instead.')

  cinder::backend::glusterfs { 'DEFAULT':
    glusterfs_shares             => $glusterfs_shares,
    glusterfs_backup_mount_point => $glusterfs_backup_mount_point,
    glusterfs_backup_share       => $glusterfs_backup_share,
    glusterfs_sparsed_volumes    => $glusterfs_sparsed_volumes,
    glusterfs_mount_point_base   => $glusterfs_mount_point_base,
    glusterfs_shares_config      => $glusterfs_shares_config,
    extra_options                => $extra_options,
  }
}
