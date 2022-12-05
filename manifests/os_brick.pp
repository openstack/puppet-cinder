# == Class: cinder::os_brick
#
# Configure os_brick options
#
# === Parameters:
#
# [*lock_path*]
#   (Optional) Directory to use for os-brick lock files.
#   Defaults to $::os_service_default
#
class cinder::os_brick(
  $lock_path = $::os_service_default,
) {

  oslo::os_brick { 'cinder_config':
    lock_path => $lock_path
  }
}
