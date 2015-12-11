# == define: cinder::backend::gpfs
#
# Configures Cinder to use the IBM GPFS Driver
#
# === Parameters
#
# [*gpfs_mount_point_base*]
#   (required) Specifies the path of the GPFS directory where Block Storage
#   volume and snapshot files are stored.
#
# [*gpfs_images_dir*]
#   (optional) Specifies the path of the Image service repository in GPFS.
#   Leave undefined if not storing images in GPFS. Defaults to "None" via
#   driver.
#   Defaults to <SERVICE DEFAULT>
#
# [*gpfs_images_share_mode*]
#   (optional) Specifies the type of image copy to be used. Set this when the
#   Image service repository also uses GPFS so that image files can be
#   transferred efficiently from the Image service to the Block Storage
#   service. There are two valid values: "copy" specifies that a full copy of
#   the image is made; "copy_on_write" specifies that copy-on-write
#   optimization strategy is used and unmodified blocks of the image file are
#   shared efficiently. Defaults to "None" via driver.
#   Defaults to <SERVICE DEFAULT>
#
# [*gpfs_max_clone_depth*]
#   (optional) Specifies an upper limit on the number of indirections required
#   to reach a specific block due to snapshots or clones. A lengthy chain of
#   copy-on-write snapshots or clones can have a negative impact on
#   performance, but improves space utilization. 0 indicates unlimited clone
#   depth. Defaults to "0" via driver implementation
#   Defaults to <SERVICE DEFAULT>
#
# [*gpfs_sparse_volumes*]
#   (optional) Specifies that volumes are created as sparse files which
#   initially consume no space. If set to False, the volume is created as a
#   fully allocated file, in which case, creation may take a significantly
#   longer time. Defaults to "True" via driver.
#   Defaults to <SERVICE DEFAULT>
#
# [*gpfs_storage_pool*]
#   (optional) Specifies the storage pool that volumes are assigned to. By
#   default, the system storage pool is used. Defaults to "system" via driver.
#   Defaults to <SERVICE DEFAULT>
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend stanza
#   Defaults to: {}
#   Example :
#     { 'gpfs_backend/param1' => { 'value' => value1 } }
#
# === Authors
#
# Benedikt von St. Vieth <b.von.st.vieth@fz-juelich.de>
#
# === Copyright
#
# Copyright 2015
#
define cinder::backend::gpfs (
  $gpfs_mount_point_base,
  $gpfs_images_dir        = '<SERVICE DEFAULT>',
  $gpfs_images_share_mode = '<SERVICE DEFAULT>',
  $gpfs_max_clone_depth   = '<SERVICE DEFAULT>',
  $gpfs_sparse_volumes    = '<SERVICE DEFAULT>',
  $gpfs_storage_pool      = '<SERVICE DEFAULT>',
  $extra_options          = {},
) {

  if ! ($gpfs_images_share_mode in ['copy', 'copy_on_write', '<SERVICE DEFAULT>']) {
    fail('gpfs_images_share_mode only support `copy` or `copy_on_write`')
  }
  if $gpfs_images_share_mode in ['copy', 'copy_on_write'] and $gpfs_images_dir == '<SERVICE DEFAULT>' {
    fail('gpfs_images_share_mode only in conjunction with gpfs_images_dir')
  }

  cinder_config {
    "${name}/volume_driver":
      value => 'cinder.volume.drivers.ibm.gpfs.GPFSDriver';
    "${name}/gpfs_max_clone_depth":   value => $gpfs_max_clone_depth;
    "${name}/gpfs_mount_point_base":  value => $gpfs_mount_point_base;
    "${name}/gpfs_sparse_volumes":    value => $gpfs_sparse_volumes;
    "${name}/gpfs_storage_pool":      value => $gpfs_storage_pool;
    "${name}/gpfs_images_share_mode": value => $gpfs_images_share_mode;
    "${name}/gpfs_images_dir":        value => $gpfs_images_dir;
  }

  create_resources('cinder_config', $extra_options)

}
