# == Define: cinder::backend::nfs
#
# === Parameters
#
# [*nfs_servers*]
#   (Required) List of available NFS shares.
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
# [*image_volume_cache_enabled*]
#   (Optional) Enable Cinder's image cache function for this backend.
#   Defaults to $facts['os_service_default'],
#
# [*image_volume_cache_max_size_gb*]
#   (Optional) Max size of the image volume cache for this backend in GB.
#   Defaults to $facts['os_service_default'],
#
# [*image_volume_cache_max_count*]
#   (Optional) Max number of entries allowed in the image volume cache.
#   Defaults to $facts['os_service_default'],
#
# [*max_over_subscription_ratio*]
#   (Optional) Representation of the over subscription ratio when thin
#   provisionig is involved.
#   Defaults to $facts['os_service_default'].
#
# [*nfs_mount_attempts*]
#   (optional) The number of attempts to mount nfs shares before raising an
#   error. At least one attempt will be made to mount an nfs share, regardless
#   of the value specified.
#   Defaults to $facts['os_service_default']
#
# [*nfs_mount_options*]
#   (Optional) Mount options passed to the nfs client.
#   Defaults to $facts['os_service_default']
#
# [*nfs_sparsed_volumes*]
#   (Optional) Create volumes as sparsed files which take no space.
#   If set to False volume is created as regular file.
#   In such case volume creation takes a lot of time.
#   Defaults to $facts['os_service_default']
#
# [*nfs_mount_point_base*]
#   (Optional) Base dir containing mount points for nfs shares.
#   Defaults to $facts['os_service_default']
#
# [*nfs_shares_config*]
#   (Optional) File with the list of available nfs shares.
#   Defaults to '/etc/cinder/shares.conf'.
#
# [*nfs_used_ratio*]
#   (Optional) Percent of ACTUAL usage of the underlying volume before no new
#   volumes can be allocated to the volume destination.
#   Defaults to $facts['os_service_default']
#
# [*nfs_oversub_ratio*]
#   (Optional) This will compare the allocated to available space on the volume
#   destination. If the ratio exceeds this number, the destination will no
#   longer be valid.
#   Defaults to $facts['os_service_default']
#
# [*nas_secure_file_operations*]
#   (Optional) Allow network-attached storage systems to operate in a secure
#   environment where root level access is not permitted. If set to False,
#   access is as the root user and insecure. If set to True, access is not as
#   root. If set to auto, a check is done to determine if this is a new
#   installation: True is used if so, otherwise False. Default is auto.
#   Defaults to $facts['os_service_default']
#
# [*nas_secure_file_permissions*]
#   (Optional) Set more secure file permissions on network-attached storage
#   volume files to restrict broad other/world access. If set to False,
#   volumes are created with open permissions. If set to True, volumes are
#   created with permissions for the cinder user and group (660). If set to
#   auto, a check is done to determine if this is a new installation: True is
#   used if so, otherwise False. Default is auto.
#   Defaults to $facts['os_service_default']
#
# [*manage_volume_type*]
#   (Optional) Whether or not manage Cinder Volume type.
#   If set to true, a Cinder Volume type will be created
#   with volume_backend_name=$volume_backend_name key/value.
#   Defaults to false.
#
# [*nfs_snapshot_support*]
#   (Optional) Enable support for snapshots on the NFS driver.
#   Platforms using libvirt <1.2.7 will encounter issues with this feature.
#   Defaults to $facts['os_service_default']
#
# [*nfs_qcow2_volumes*]
#   (Optional) Create volumes as QCOW2 files rather than raw files.
#   Defaults to $facts['os_service_default']
#
# [*package_ensure*]
#   (optional) Ensure state for package. Defaults to 'present'.
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend stanza
#   Defaults to: {}
#   Example :
#     { 'nfs_backend/param1' => { 'value' => value1 } }
#
define cinder::backend::nfs (
  Array[String[1], 1] $nfs_servers,
  $volume_backend_name                    = $name,
  $backend_availability_zone              = $facts['os_service_default'],
  $image_volume_cache_enabled             = $facts['os_service_default'],
  $image_volume_cache_max_size_gb         = $facts['os_service_default'],
  $image_volume_cache_max_count           = $facts['os_service_default'],
  $max_over_subscription_ratio            = $facts['os_service_default'],
  $nfs_mount_attempts                     = $facts['os_service_default'],
  $nfs_mount_options                      = $facts['os_service_default'],
  $nfs_sparsed_volumes                    = $facts['os_service_default'],
  $nfs_mount_point_base                   = $facts['os_service_default'],
  Stdlib::Absolutepath $nfs_shares_config = '/etc/cinder/shares.conf',
  $nfs_used_ratio                         = $facts['os_service_default'],
  $nfs_oversub_ratio                      = $facts['os_service_default'],
  $nas_secure_file_operations             = $facts['os_service_default'],
  $nas_secure_file_permissions            = $facts['os_service_default'],
  $nfs_snapshot_support                   = $facts['os_service_default'],
  $nfs_qcow2_volumes                      = $facts['os_service_default'],
  $package_ensure                         = 'present',
  Boolean $manage_volume_type             = false,
  Hash $extra_options                     = {},
) {

  include cinder::deps
  include cinder::params

  file { $nfs_shares_config:
    content => join($nfs_servers, "\n"),
    require => Anchor['cinder::install::end'],
    notify  => Anchor['cinder::service::begin'],
  }

  cinder_config {
    "${name}/volume_backend_name":            value => $volume_backend_name;
    "${name}/backend_availability_zone":      value => $backend_availability_zone;
    "${name}/image_volume_cache_enabled":     value => $image_volume_cache_enabled;
    "${name}/image_volume_cache_max_size_gb": value => $image_volume_cache_max_size_gb;
    "${name}/image_volume_cache_max_count":   value => $image_volume_cache_max_count;
    "${name}/max_over_subscription_ratio":    value => $max_over_subscription_ratio;
    "${name}/volume_driver":                  value => 'cinder.volume.drivers.nfs.NfsDriver';
    "${name}/nfs_shares_config":              value => $nfs_shares_config;
    "${name}/nfs_mount_attempts":             value => $nfs_mount_attempts;
    "${name}/nfs_mount_options":              value => $nfs_mount_options;
    "${name}/nfs_sparsed_volumes":            value => $nfs_sparsed_volumes;
    "${name}/nfs_mount_point_base":           value => $nfs_mount_point_base;
    "${name}/nfs_used_ratio":                 value => $nfs_used_ratio;
    "${name}/nfs_oversub_ratio":              value => $nfs_oversub_ratio;
    "${name}/nfs_snapshot_support":           value => $nfs_snapshot_support;
    "${name}/nfs_qcow2_volumes":              value => $nfs_qcow2_volumes;
    "${name}/nas_secure_file_operations":     value => $nas_secure_file_operations;
    "${name}/nas_secure_file_permissions":    value => $nas_secure_file_permissions;
  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => {'volume_backend_name' => $volume_backend_name},
    }
  }

  ensure_packages('nfs-client', {
    name   => $::cinder::params::nfs_client_package_name,
    ensure => $package_ensure,
  })
  Package<| title == 'nfs-client' |> { tag +> 'cinder-support-package' }

  create_resources('cinder_config', $extra_options)

}
