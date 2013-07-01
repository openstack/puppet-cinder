#
class cinder::volume::nfs (
  $nfs_servers = [],
  $nfs_mount_options = undef,
  $nfs_disk_util = undef,
  $nfs_sparsed_volumes = undef,
  $nfs_mount_point_base = undef,
  $nfs_shares_config = '/etc/cinder/shares.conf'
) {

  file {$nfs_shares_config:
    content => join($nfs_servers, "\n"),
    require => Package['cinder'],
    notify  => Service['cinder-volume']
  }

  cinder_config {
    'DEFAULT/volume_driver':        value =>
      'cinder.volume.drivers.nfs.NfsDriver';
    'DEFAULT/nfs_shares_config':    value => $nfs_shares_config;
    'DEFAULT/nfs_mount_options':    value => $nfs_mount_options;
    'DEFAULT/nfs_disk_util':        value => $nfs_disk_util;
    'DEFAULT/nfs_sparsed_volumes':  value => $nfs_sparsed_volumes;
    'DEFAULT/nfs_mount_point_base': value => $nfs_mount_point_base;
  }
}
