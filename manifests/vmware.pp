# == Class: cinder::vmware
#
# Creates vmdk specific disk file type & clone type.
#
# === Parameters
#
# [*os_password*]
#   DEPRECATED. The keystone tenant:username password.
#   Defaults to undef.
#
# [*os_tenant_name*]
#   DEPRECATED. The keystone tenant name.
#   Defaults to undef.
#
# [*os_username*]
#   DEPRECATED. The keystone user name.
#   Defaults to undef.
#
# [*os_auth_url*]
#   DEPRECATED. The keystone auth url.
#   Defaults to undef.
#
class cinder::vmware (
  $os_password    = undef,
  $os_tenant_name = undef,
  $os_username    = undef,
  $os_auth_url    = undef
) {

  include ::cinder::deps

  if $os_password or $os_tenant_name or $os_username or $os_auth_url {
    warning('Parameters $os_password/$os_tenant_name/$os_username/$os_auth_url are not longer required.')
    warning('Auth creds will be used from env or /root/openrc file or cinder.conf')
  }

  cinder_type { 'vmware-thin':
    ensure     => present,
    properties => ['vmware:vmdk_type=thin']
  }

  cinder_type { 'vmware-thick':
    ensure     => present,
    properties => ['vmware:vmdk_type=thick']
  }

  cinder_type { 'vmware-eagerZeroedThick':
    ensure     => present,
    properties => ['vmware:vmdk_type=eagerZeroedThick']
  }

  cinder_type { 'vmware-full':
    ensure     => present,
    properties => ['vmware:clone_type=full']
  }

  cinder_type { 'vmware-linked':
    ensure     => present,
    properties => ['vmware:clone_type=linked']
  }
}
