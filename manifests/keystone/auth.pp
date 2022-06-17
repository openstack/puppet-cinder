# == Class: cinder::keystone::auth
#
# Configures Cinder user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (Required) Password for Cinder user.
#
# [*email*]
#   (Optional) Email for Cinder user.
#   Defaults to 'cinder@localhost'.
#
# [*password_user_v3*]
#   (Optional) Password for Cinder v3 user.
#   Defaults to undef.
#
# [*email_user_v3*]
#   (Optional) Email for Cinder v3 user.
#   Defaults to 'cinderv3@localhost'.
#
# [*auth_name*]
#   (Optional) Username for Cinder service.
#   Defaults to 'cinder'.
#
# [*auth_name_v3*]
#   (Optional) Username for Cinder v3 service.
#   Defaults to 'cinderv3'.
#
# [*configure_endpoint_v3*]
#   (Optional) Should Cinder v3 endpoint be configured?
#   Defaults to true
#
# [*configure_user*]
#   (Optional) Should the service user be configured?
#   Defaults to true
#
# [*configure_user_v3*]
#   (Optional) Should the service user be configured for cinder v3?
#   Defaults to false
#
# [*configure_user_role*]
#   (Optional) Should the admin role be configured for the service user?
#   Defaults to true
#
# [*configure_user_role_v3*]
#   (Optional) Should the admin role be configured for the service user for cinder v3?
#   Defaults to false
#
# [*service_name_v3*]
#   (Optional) Name of the v3 service.
#   Defaults to 'cinderv3'.
#
# [*service_type_v3*]
#   (Optional) Type of API v3 service.
#   Defaults to 'volumev3'.
#
# [*service_description_v3*]
#   (Optional) Description for keystone v3 service.
#   Defaults to 'Cinder Service v3'.
#
# [*region*]
#   (Optional) Region for endpoint.
#   Defaults to 'RegionOne'.
#
# [*tenant*]
#   (Optional) Tenant for Cinder user.
#   Defaults to 'services'.
#
# [*tenant_user_v3*]
#   (Optional) Tenant for Cinder v3 user.
#   Defaults to 'services'.
#
# [*roles*]
#   (Optional) List of roles assigned to Cinder user
#   Defaults to ['admin']
#
# [*roles_v3*]
#   (Optional) List of roles assigned to Cinder v3 user
#   Defaults to ['admin']
#
# [*system_scope*]
#   (Optional) Scope for system operations used by Cinder v3 user.
#   Defaults to 'all'
#
# [*system_scope_v3*]
#   (Optional) Scope for system operations used by Cinder v3 user.
#   Defaults to 'all'
#
# [*system_roles*]
#   (Optional) List of system roles assigned to Cinder user.
#   Defaults to []
#
# [*system_roles_v3*]
#   (Optional) List of system roles assigned to Cinder v3 user.
#   Defaults to []
#
# [*public_url_v3*]
#   (Optional) The v3 endpoint's public url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8776/v3'
#
# [*internal_url_v3*]
#   (Optional) The v3 endpoint's internal url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8776/v3'
#
# [*admin_url_v3*]
#   (Optional) The v3 endpoint's admin url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8776/v3'
#
# === Examples
#
#  class { 'cinder::keystone::auth':
#    public_url   => 'https://10.0.0.10:8776/v3',
#    internal_url => 'https://10.0.0.20:8776/v3',
#    admin_url    => 'https://10.0.0.30:8776/v3',
#  }
#
class cinder::keystone::auth (
  $password,
  $password_user_v3       = undef,
  $auth_name              = 'cinder',
  $auth_name_v3           = 'cinderv3',
  $tenant                 = 'services',
  $tenant_user_v3         = 'services',
  $roles                  = ['admin'],
  $roles_v3               = ['admin'],
  $system_scope           = 'all',
  $system_scope_v3        = 'all',
  $system_roles           = [],
  $system_roles_v3        = [],
  $email                  = 'cinder@localhost',
  $email_user_v3          = 'cinderv3@localhost',
  $public_url_v3          = 'http://127.0.0.1:8776/v3',
  $internal_url_v3        = 'http://127.0.0.1:8776/v3',
  $admin_url_v3           = 'http://127.0.0.1:8776/v3',
  $configure_endpoint_v3  = true,
  $configure_user         = true,
  $configure_user_v3      = false,
  $configure_user_role    = true,
  $configure_user_role_v3 = false,
  $service_name_v3        = 'cinderv3',
  $service_type_v3        = 'volumev3',
  $service_description_v3 = 'Cinder Service v3',
  $region                 = 'RegionOne',
) {

  include cinder::deps

  Keystone::Resource::Service_identity['cinder'] -> Anchor['cinder::service::end']
  Keystone::Resource::Service_identity['cinderv3'] -> Anchor['cinder::service::end']

  # Always configure the original user and user roles, as these
  # can be used by the v3 service.
  keystone::resource::service_identity { 'cinder':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => false,
    configure_service   => false,
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    roles               => $roles,
    system_scope        => $system_scope,
    system_roles        => $system_roles,
  }

  keystone::resource::service_identity { 'cinderv3':
    configure_user      => $configure_user_v3,
    configure_user_role => $configure_user_role_v3,
    configure_endpoint  => $configure_endpoint_v3,
    service_type        => $service_type_v3,
    service_description => $service_description_v3,
    service_name        => $service_name_v3,
    region              => $region,
    auth_name           => $auth_name_v3,
    password            => $password_user_v3,
    email               => $email_user_v3,
    tenant              => $tenant_user_v3,
    roles               => $roles_v3,
    system_scope        => $system_scope_v3,
    system_roles        => $system_roles_v3,
    public_url          => $public_url_v3,
    admin_url           => $admin_url_v3,
    internal_url        => $internal_url_v3,
  }

}
