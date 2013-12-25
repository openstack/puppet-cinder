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
# [*glusterfs_disk_util*]
#   Removed in Icehouse.
#
# [*glusterfs_sparsed_volumes*]
#   (optional) Whether or not to use sparse (thin) volumes.
#   Defaults to undef which uses the driver's default of "true".
#
# [*glusterfs_mount_point_base*]
#   (optional) Where to mount the Gluster volumes.
#   Defaults to undef which uses the driver's default of "$state_path/mnt".
#
# [*glusterfs_shares_config*]
#   (optional) The config file to store the given $glusterfs_shares.
#   Defaults to '/etc/cinder/shares.conf'
#
# === Examples
#
# class { 'cinder::volume::glusterfs':
#   glusterfs_shares = ['192.168.1.1:/volumes'],
# }
#
class cinder::volume::glusterfs (
  $glusterfs_shares,
  $glusterfs_disk_util        = false,
  $glusterfs_sparsed_volumes  = undef,
  $glusterfs_mount_point_base = undef,
  $glusterfs_shares_config    = '/etc/cinder/shares.conf'
) {

  if $glusterfs_disk_util {
    fail('glusterfs_disk_util is removed in Icehouse.')
  }

  $content = join($glusterfs_shares, "\n")

  file {$glusterfs_shares_config:
    content => "${content}\n",
    require => Package['cinder'],
    notify  => Service['cinder-volume']
  }

  cinder_config {
    'DEFAULT/volume_driver':        value =>
      'cinder.volume.drivers.glusterfs.GlusterfsDriver';
    'DEFAULT/glusterfs_shares_config':    value => $glusterfs_shares_config;
    'DEFAULT/glusterfs_sparsed_volumes':  value => $glusterfs_sparsed_volumes;
    'DEFAULT/glusterfs_mount_point_base': value => $glusterfs_mount_point_base;
  }
}
