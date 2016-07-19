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
  $manage_volume_type     = false,
  $extra_options          = {},
) {

  include ::cinder::deps

  if ! ($gpfs_images_share_mode in ['copy', 'copy_on_write', $::os_service_default]) {
    fail('gpfs_images_share_mode only support `copy` or `copy_on_write`')
  }
  if $gpfs_images_share_mode in ['copy', 'copy_on_write'] and is_service_default($gpfs_images_dir) {
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
    "${name}/nas_host":               value => $nas_host;
    "${name}/nas_login":              value => $nas_login;
    "${name}/nas_password":           value => $nas_password;
    "${name}/nas_private_key":        value => $nas_private_key;
    "${name}/nas_ssh_port":           value => $nas_ssh_port;
  }

  if $manage_volume_type {
    cinder_type { $name:
      ensure     => present,
      properties => ["volume_backend_name=${name}"],
    }
  }

  create_resources('cinder_config', $extra_options)

}
