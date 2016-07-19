# ==Define: cinder::type_set
#
# Assigns keys after the volume type is set.
# Deprecated class.
#
# === Parameters
#
# [*type*]
#   (required) Accepts single name of type to set.
#
# [*key*]
#   (required) the key name that we are setting the value for.
#
# [*value*]
#   the value that we are setting. Defaults to content of namevar.
#
# === Deprecated parameters
#
# [*os_password*]
#   (optional) DEPRECATED: The keystone tenant:username password.
#   Defaults to undef.
#
# [*os_tenant_name*]
#   (optional) DEPRECATED: The keystone tenant name. Defaults to undef.
#
# [*os_username*]
#   (optional) DEPRECATED: The keystone user name. Defaults to undef.
#
# [*os_auth_url*]
#   (optional) DEPRECATED: The keystone auth url. Defaults to undef.
#
# [*os_region_name*]
#   (optional) DEPRECATED: The keystone region name. Default is undef.
#
# Author: Andrew Woodward <awoodward@mirantis.com>
#
define cinder::type_set (
  $type,
  $key,
  $value          = $name,
  # DEPRECATED PARAMETERS
  $os_password    = undef,
  $os_tenant_name = undef,
  $os_username    = undef,
  $os_auth_url    = undef,
  $os_region_name = undef,
  ) {

  include ::cinder::deps

  if $os_password or $os_region_name or $os_tenant_name or $os_username or $os_auth_url {
    warning('Parameters $os_password/$os_region_name/$os_tenant_name/$os_username/$os_auth_url are not longer required.')
    warning('Auth creds will be used from env or /root/openrc file or cinder.conf')
  }

  cinder_type { $type:
    ensure     => present,
    properties => ["${key}=${value}"],
  }
}
