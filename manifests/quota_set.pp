# == Class: cinder::quota_set
#
# Setup and configure Cinder quotas per volume type.
#
# === Parameters
#
# [*os_password*]
#   (Required) The keystone tenant:username password.
#
# [*os_tenant_name*]
#   (Optional) The keystone tenant name.
#   Defaults to 'admin'.
#
# [*os_username*]
#   (Optional) The keystone user name.
#   Defaults to 'admin'.
#
# [*os_auth_url*]
#   (Optional) The keystone auth url.
#   Defaults to 'http://127.0.0.1:5000/v2.0/'.
#
# [*os_region_name*]
#   (Optional) The keystone region name.
#   Default is unset.
#
# [*quota_volumes*]
#   (Optional) Number of volumes allowed per project.
#   Defaults to 10.
#
# [*quota_snapshots*]
#   (Optional) Number of volume snapshots allowed per project.
#   Defaults to 10.
#
# [*quota_gigabytes*]
#   (Optional) Number of volume gigabytes (snapshots are also included)
#   allowed per project.
#   Defaults to 1000.
#
# [*class_name*]
#   (Optional) Quota class to use.
#   Defaults to 'default'.
#
# [*volume_type*]
#   volume type that will have quota changed
#   Defaults to $name
#

define cinder::quota_set (
  $os_password,
  $os_tenant_name  = 'admin',
  $os_username     = 'admin',
  $os_auth_url     = 'http://127.0.0.1:5000/v2.0/',
  $os_region_name  = undef,
  $quota_volumes   = 10,
  $quota_snapshots = 10,
  $quota_gigabytes = 1000,
  $class_name      = 'default',
  $volume_type     = $name,
) {

  include ::cinder::deps

  if $os_region_name {
    $cinder_env = [
      "OS_TENANT_NAME=${os_tenant_name}",
      "OS_USERNAME=${os_username}",
      "OS_PASSWORD=${os_password}",
      "OS_AUTH_URL=${os_auth_url}",
      "OS_REGION_NAME=${os_region_name}",
    ]
  }
  else {
    $cinder_env = [
      "OS_TENANT_NAME=${os_tenant_name}",
      "OS_USERNAME=${os_username}",
      "OS_PASSWORD=${os_password}",
      "OS_AUTH_URL=${os_auth_url}",
    ]
  }

  exec {"openstack quota set --class ${class_name}":
    # lint:ignore:140chars
    command     => "openstack quota set --class ${class_name} --volumes ${quota_volumes} --snapshots ${quota_snapshots} --gigabytes ${quota_gigabytes} --volume-type '${volume_type}'",
    # lint:endignore
    onlyif      => 'openstack quota show --class default | grep -qP -- -1',
    environment => $cinder_env,
    require     => Anchor['cinder::install::end'],
    path        => ['/usr/bin', '/bin'],
  }
}
