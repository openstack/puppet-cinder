# == Define: cinder::type
#
# Creates cinder type and assigns backends.
# Deprecated class.
#
# === Parameters
#
# [*os_password*]
#   (Required) The keystone tenant:username password.
#
# [*set_key*]
#   (Optional) Must be used with set_value. Accepts a single string be used
#   as the key in type_set
#   Defaults to 'undef'.
#
# [*set_value*]
#   (optional) Accepts list of strings or singular string. A list of values
#   passed to type_set
#   Defaults to 'undef'.
#
# === DEPRECATED PARAMETERS
#
# [*os_tenant_name*]
#   (Optional) The keystone tenant name.
#   Defaults to undef.
#
# [*os_username*]
#   (Optional) The keystone user name.
#   Defaults to undef.
#
# [*os_auth_url*]
#   (Optional) The keystone auth url.
#   Defaults to undef.
#
# [*os_region_name*]
#   (Optional) The keystone region name.
#   Default is undef.
#
# Author: Andrew Woodward <awoodward@mirantis.com>
#
define cinder::type (
  $set_key        = undef,
  $set_value      = undef,
  # DEPRECATED PARAMETERS
  $os_password    = undef,
  $os_tenant_name = undef,
  $os_username    = undef,
  $os_auth_url    = undef,
  $os_region_name = undef,
  ) {

  include ::cinder::deps

  if $os_password or $os_region_name or $os_tenant_name or $os_username or $os_auth_url {
    warning('Parameters $os_password/$os_region_name/$os_tenant_name/$os_username/$os_auth_url are not longer required')
    warning('Auth creds will be used from env or /root/openrc file or cinder.conf')
  }

  if ($set_value and $set_key) {
    if is_array($set_value) {
      $value = join($set_value, ',')
    } else {
      $value = $set_value
    }
    cinder_type { $name:
      ensure     => present,
      properties => ["${set_key}=${value}"],
    }
  } else {
    cinder_type { $name:
      ensure     => present,
    }
  }
}
