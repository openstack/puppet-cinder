# == Class: cinder::volume::gpfs
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
#   Defaults to $::os_service_default
#
# [*gpfs_images_share_mode*]
#   (optional) Specifies the type of image copy to be used. Set this when the
#   Image service repository also uses GPFS so that image files can be
#   transferred efficiently from the Image service to the Block Storage
#   service. There are two valid values: "copy" specifies that a full copy of
#   the image is made; "copy_on_write" specifies that copy-on-write
#   optimization strategy is used and unmodified blocks of the image file are
#   shared efficiently. Defaults to "None" via driver.
#   Defaults to $::os_service_default
#
# [*gpfs_max_clone_depth*]
#   (optional) Specifies an upper limit on the number of indirections required
#   to reach a specific block due to snapshots or clones. A lengthy chain of
#   copy-on-write snapshots or clones can have a negative impact on
#   performance, but improves space utilization. 0 indicates unlimited clone
#   depth. Defaults to "0" via driver implementation
#   Defaults to $::os_service_default
#
# [*gpfs_sparse_volumes*]
#   (optional) Specifies that volumes are created as sparse files which
#   initially consume no space. If set to False, the volume is created as a
#   fully allocated file, in which case, creation may take a significantly
#   longer time. Defaults to "True" via driver.
#   Defaults to $::os_service_default
#
# [*gpfs_storage_pool*]
#   (optional) Specifies the storage pool that volumes are assigned to. By
#   default, the system storage pool is used. Defaults to "system" via driver.
#   Defaults to $::os_service_default
#
# [*nas_host*]
#   (optional) IP address or Hostname of the NAS system.
#   Defaults to $::os_service_default
#
# [*nas_login*]
#   (optional) User name to connect to NAS system.
#   Defaults to $::os_service_default
#
# [*nas_password*]
#   (optional) Password to connect to NAS system.
#   Defaults to $::os_service_default
#
# [*nas_private_key*]
#   (optional) Filename of private key to use for SSH authentication.
#   Defaults to $::os_service_default
#
# [*nas_ssh_port*]
#   (optional) SSH port to use to connect to NAS system.
#   Defaults to $::os_service_default
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
class cinder::volume::gpfs(
  $gpfs_mount_point_base,
  $gpfs_images_dir        = $::os_service_default,
  $gpfs_images_share_mode = $::os_service_default,
  $gpfs_max_clone_depth   = $::os_service_default,
  $gpfs_sparse_volumes    = $::os_service_default,
  $gpfs_storage_pool      = $::os_service_default,
  $nas_host               = $::os_service_default,
  $nas_login              = $::os_service_default,
  $nas_password           = $::os_service_default,
  $nas_private_key        = $::os_service_default,
  $nas_ssh_port           = $::os_service_default,
  $extra_options          = {}
) {

  include ::cinder::deps

  warning('Usage of cinder::volume::gpfs is deprecated, please use
cinder::backend::gpfs instead.')

  cinder::backend::gpfs { 'DEFAULT':
    gpfs_mount_point_base  => $gpfs_mount_point_base,
    gpfs_images_dir        => $gpfs_images_dir,
    gpfs_images_share_mode => $gpfs_images_share_mode,
    gpfs_max_clone_depth   => $gpfs_max_clone_depth,
    gpfs_sparse_volumes    => $gpfs_sparse_volumes,
    gpfs_storage_pool      => $gpfs_storage_pool,
    nas_host               => $nas_host,
    nas_login              => $nas_login,
    nas_password           => $nas_password,
    nas_private_key        => $nas_private_key,
    nas_ssh_port           => $nas_ssh_port,
    extra_options          => $extra_options,
  }
}
