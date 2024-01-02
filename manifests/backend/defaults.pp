# == Class: cinder::backend::defaults
#
# Cinder backend defaults
#
# === Parameters
#
# [*use_multipath_for_image_xfer*]
#   (Optional) Whether to use multipath during create-volume-from-image and
#   copy-volume-to-image operations.
#   Defaults to $facts['os_service_default']
#
# [*image_volume_cache_enabled*]
#   (Optional) Enable Cinder's image cache function.
#   Defaults to $facts['os_service_default'],
#
# [*image_volume_cache_max_size_gb*]
#   (Optional) Max size of the image volume cache in GB.
#   Defaults to $facts['os_service_default'],
#
# [*image_volume_cache_max_count*]
#   (Optional) Max number of entries allowed in the image volume cache.
#   Defaults to $facts['os_service_default'],
#
class cinder::backend::defaults (
  $use_multipath_for_image_xfer   = $facts['os_service_default'],
  $image_volume_cache_enabled     = $facts['os_service_default'],
  $image_volume_cache_max_size_gb = $facts['os_service_default'],
  $image_volume_cache_max_count   = $facts['os_service_default'],
) {

  include cinder::deps

  cinder_config {
    'backend_defaults/use_multipath_for_image_xfer':   value => $use_multipath_for_image_xfer;
    'backend_defaults/image_volume_cache_enabled':     value => $image_volume_cache_enabled;
    'backend_defaults/image_volume_cache_max_size_gb': value => $image_volume_cache_max_size_gb;
    'backend_defaults/image_volume_cache_max_count':   value => $image_volume_cache_max_count;
  }
}
