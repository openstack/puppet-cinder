# == Class: cinder::keystone::auth
#
# Configures Cinder user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   Password for Cinder user. Required.
#
# [*email*]
#   Email for Cinder user. Optional. Defaults to 'cinder@localhost'.
#
# [*password_user_v2*]
#   Password for Cinder v2 user. Optional. Defaults to undef.
#
# [*email_user_v2*]
#   Email for Cinder v2 user. Optional. Defaults to 'cinderv2@localhost'.
#
# [*password_user_v3*]
#   Password for Cinder v3 user. Optional. Defaults to undef.
#
# [*email_user_v3*]
#   Email for Cinder v3 user. Optional. Defaults to 'cinderv3@localhost'.
#
# [*auth_name*]
#   Username for Cinder service. Optional. Defaults to 'cinder'.
#
# [*auth_name_v2*]
#   Username for Cinder v2 service. Optional. Defaults to 'cinderv2'.
#
# [*auth_name_v3*]
#   Username for Cinder v3 service. Optional. Defaults to 'cinderv3'.
#
# [*configure_endpoint*]
#   Should Cinder endpoint be configured? Optional. Defaults to 'true'.
#   API v1 endpoint should be enabled in Icehouse for compatibility with Nova.
#
# [*configure_endpoint_v2*]
#   Should Cinder v2 endpoint be configured? Optional. Defaults to 'true'.
#
# [*configure_endpoint_v3*]
#   Should Cinder v3 endpoint be configured? Optional. Defaults to 'true'.
#
# [*configure_user*]
#   Should the service user be configured? Optional. Defaults to 'true'.
#
# [*configure_user_v2*]
#   Should the service user be configured for cinder v2? Optional. Defaults to 'false'.
#
# [*configure_user_v3*]
#   Should the service user be configured for cinder v3? Optional. Defaults to 'false'.
#
# [*configure_user_role*]
#   Should the admin role be configured for the service user?
#   Optional. Defaults to 'true'.
#
# [*configure_user_role_v2*]
#   Should the admin role be configured for the service user for cinder v2?
#   Optional. Defaults to 'false'.
#
# [*configure_user_role_v3*]
#   Should the admin role be configured for the service user for cinder v3?
#   Optional. Defaults to 'false'.
#
# [*service_name*]
#   (optional) Name of the service.
#   Defaults to 'cinder'.
#
# [*service_name_v2*]
#   (optional) Name of the v2 service.
#   Defaults to 'cinderv2'.
#
# [*service_name_v3*]
#   (optional) Name of the v3 service.
#   Defaults to 'cinderv3'.
#
# [*service_type*]
#    Type of service. Optional. Defaults to 'volume'.
#
# [*service_type_v2*]
#    Type of API v2 service. Optional. Defaults to 'volumev2'.
#
# [*service_type_v3*]
#    Type of API v3 service. Optional. Defaults to 'volumev3'.
#
# [*service_description*]
#    (optional) Description for keystone service.
#    Defaults to 'Cinder Service'.
#
# [*service_description_v2*]
#    (optional) Description for keystone v2 service.
#    Defaults to 'Cinder Service v2'.
#
# [*service_description_v3*]
#    (optional) Description for keystone v3 service.
#    Defaults to 'Cinder Service v3'.
#
# [*region*]
#    Region for endpoint. Optional. Defaults to 'RegionOne'.
#
# [*tenant*]
#    Tenant for Cinder user. Optional. Defaults to 'services'.
#
# [*tenant_user_v2*]
#    Tenant for Cinder v2 user. Optional. Defaults to 'services'.
#
# [*tenant_user_v3*]
#    Tenant for Cinder v3 user. Optional. Defaults to 'services'.
#
# [*public_url*]
#   (optional) The endpoint's public url. (Defaults to 'http://127.0.0.1:8776/v1/%(tenant_id)s')
#   This url should *not* contain any trailing '/'.
#
# [*internal_url*]
#   (optional) The endpoint's internal url. (Defaults to 'http://127.0.0.1:8776/v1/%(tenant_id)s')
#   This url should *not* contain any trailing '/'.
#
# [*admin_url*]
#   (optional) The endpoint's admin url. (Defaults to 'http://127.0.0.1:8776/v1/%(tenant_id)s')
#   This url should *not* contain any trailing '/'.
#
# [*public_url_v2*]
#   (optional) The v2 endpoint's public url. (Defaults to 'http://127.0.0.1:8776/v2/%(tenant_id)s')
#   This url should *not* contain any trailing '/'.
#
# [*internal_url_v2*]
#   (optional) The v2 endpoint's internal url. (Defaults to 'http://127.0.0.1:8776/v2/%(tenant_id)s')
#   This url should *not* contain any trailing '/'.
#
# [*admin_url_v2*]
#   (optional) The v2 endpoint's admin url. (Defaults to 'http://127.0.0.1:8776/v2/%(tenant_id)s')
#   This url should *not* contain any trailing '/'.
#
# [*public_url_v3*]
#   (optional) The v3 endpoint's public url. (Defaults to 'http://127.0.0.1:8776/v3/%(tenant_id)s')
#   This url should *not* contain any trailing '/'.
#
# [*internal_url_v3*]
#   (optional) The v3 endpoint's internal url. (Defaults to 'http://127.0.0.1:8776/v3/%(tenant_id)s')
#   This url should *not* contain any trailing '/'.
#
# [*admin_url_v3*]
#   (optional) The v3 endpoint's admin url. (Defaults to 'http://127.0.0.1:8776/v3/%(tenant_id)s')
#   This url should *not* contain any trailing '/'.
#
# === Examples
#
#  class { 'cinder::keystone::auth':
#    public_url   => 'https://10.0.0.10:8776/v1/%(tenant_id)s',
#    internal_url => 'https://10.0.0.20:8776/v1/%(tenant_id)s',
#    admin_url    => 'https://10.0.0.30:8776/v1/%(tenant_id)s',
#  }
#
class cinder::keystone::auth (
  $password,
  $password_user_v2       = undef,
  $password_user_v3       = undef,
  $auth_name              = 'cinder',
  $auth_name_v2           = 'cinderv2',
  $auth_name_v3           = 'cinderv3',
  $tenant                 = 'services',
  $tenant_user_v2         = 'services',
  $tenant_user_v3         = 'services',
  $email                  = 'cinder@localhost',
  $email_user_v2          = 'cinderv2@localhost',
  $email_user_v3          = 'cinderv3@localhost',
  $public_url             = 'http://127.0.0.1:8776/v1/%(tenant_id)s',
  $internal_url           = 'http://127.0.0.1:8776/v1/%(tenant_id)s',
  $admin_url              = 'http://127.0.0.1:8776/v1/%(tenant_id)s',
  $public_url_v2          = 'http://127.0.0.1:8776/v2/%(tenant_id)s',
  $internal_url_v2        = 'http://127.0.0.1:8776/v2/%(tenant_id)s',
  $admin_url_v2           = 'http://127.0.0.1:8776/v2/%(tenant_id)s',
  $public_url_v3          = 'http://127.0.0.1:8776/v3/%(tenant_id)s',
  $internal_url_v3        = 'http://127.0.0.1:8776/v3/%(tenant_id)s',
  $admin_url_v3           = 'http://127.0.0.1:8776/v3/%(tenant_id)s',
  $configure_endpoint     = true,
  $configure_endpoint_v2  = true,
  $configure_endpoint_v3  = true,
  $configure_user         = true,
  $configure_user_v2      = false,
  $configure_user_v3      = false,
  $configure_user_role    = true,
  $configure_user_role_v2 = false,
  $configure_user_role_v3 = false,
  $service_name           = 'cinder',
  $service_name_v2        = 'cinderv2',
  $service_name_v3        = 'cinderv3',
  $service_type           = 'volume',
  $service_type_v2        = 'volumev2',
  $service_type_v3        = 'volumev3',
  $service_description    = 'Cinder Service',
  $service_description_v2 = 'Cinder Service v2',
  $service_description_v3 = 'Cinder Service v3',
  $region                 = 'RegionOne',
) {

  include ::cinder::deps

  if $configure_endpoint {
    Keystone_endpoint["${region}/${service_name}::${service_type}"] -> Anchor['cinder::service::end']
  }
  if $configure_endpoint_v2 {
    Keystone_endpoint["${region}/${service_name_v2}::${service_type_v2}"] -> Anchor['cinder::service::end']
  }
  if $configure_endpoint_v3 {
    Keystone_endpoint["${region}/${service_name_v3}::${service_type_v3}"] -> Anchor['cinder::service::end']
  }

  keystone::resource::service_identity { 'cinder':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_type        => $service_type,
    service_description => $service_description,
    service_name        => $service_name,
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    public_url          => $public_url,
    admin_url           => $admin_url,
    internal_url        => $internal_url,
  }

  keystone::resource::service_identity { 'cinderv2':
    configure_user      => $configure_user_v2,
    configure_user_role => $configure_user_role_v2,
    configure_endpoint  => $configure_endpoint_v2,
    service_type        => $service_type_v2,
    service_description => $service_description_v2,
    service_name        => $service_name_v2,
    region              => $region,
    auth_name           => $auth_name_v2,
    password            => $password_user_v2,
    email               => $email_user_v2,
    tenant              => $tenant_user_v2,
    public_url          => $public_url_v2,
    admin_url           => $admin_url_v2,
    internal_url        => $internal_url_v2,
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
    public_url          => $public_url_v3,
    admin_url           => $admin_url_v3,
    internal_url        => $internal_url_v3,
  }

  if $configure_user_role {
    Keystone_user_role["${auth_name}@${tenant}"] -> Anchor['cinder::service::end']
  }

}
