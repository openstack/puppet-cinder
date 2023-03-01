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
class cinder::backend::defaults (
  $use_multipath_for_image_xfer = $facts['os_service_default'],
) {

  include cinder::deps

  cinder_config {
    'backend_defaults/use_multipath_for_image_xfer': value => $use_multipath_for_image_xfer;
  }
}
