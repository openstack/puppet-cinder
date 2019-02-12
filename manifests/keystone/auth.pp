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
# [*password_user_v2*]
#   (Optional) Password for Cinder v2 user.
#   Defaults to undef.
#
# [*email_user_v2*]
#   (Optional) Email for Cinder v2 user.
#   Defaults to 'cinderv2@localhost'.
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
# [*auth_name_v2*]
#   (Optional) Username for Cinder v2 service.
#   Defaults to 'cinderv2'.
#
# [*auth_name_v3*]
#   (Optional) Username for Cinder v3 service.
#   Defaults to 'cinderv3'.
#
# [*configure_endpoint_v2*]
#   (Optional) Should Cinder v2 endpoint be configured?
#   Defaults to true
#
# [*configure_endpoint_v3*]
#   (Optional) Should Cinder v3 endpoint be configured?
#   Defaults to true
#
# [*configure_user*]
#   (Optional) Should the service user be configured?
#   Defaults to true
#
# [*configure_user_v2*]
#   (Optional) Should the service user be configured for cinder v2?
#   Defaults to false
#
# [*configure_user_v3*]
#   (Optional) Should the service user be configured for cinder v3?
#   Defaults to false
#
# [*configure_user_role*]
#   (Optional) Should the admin role be configured for the service user?
#   Defaults to true
#
# [*configure_user_role_v2*]
#   (Optional) Should the admin role be configured for the service user for cinder v2?
#   Defaults to false
#
# [*configure_user_role_v3*]
#   (Optional) Should the admin role be configured for the service user for cinder v3?
#   Defaults to false
#
# [*service_name_v2*]
#   (Optional) Name of the v2 service.
#   Defaults to 'cinderv2'.
#
# [*service_name_v3*]
#   (Optional) Name of the v3 service.
#   Defaults to 'cinderv3'.
#
# [*service_type_v2*]
#   (Optional) Type of API v2 service.
#   Defaults to 'volumev2'.
#
# [*service_type_v3*]
#   (Optional) Type of API v3 service.
#   Defaults to 'volumev3'.
#
# [*service_description_v2*]
#   (Optional) Description for keystone v2 service.
#   Defaults to 'Cinder Service v2'.
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
# [*tenant_user_v2*]
#   (Optional) Tenant for Cinder v2 user.
#   Defaults to 'services'.
#
# [*tenant_user_v3*]
#   (Optional) Tenant for Cinder v3 user.
#   Defaults to 'services'.
#
# [*public_url_v2*]
#   (Optional) The v2 endpoint's public url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8776/v2/%(tenant_id)s'
#
# [*internal_url_v2*]
#   (Optional) The v2 endpoint's internal url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8776/v2/%(tenant_id)s'
#
# [*admin_url_v2*]
#   (Optional) The v2 endpoint's admin url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8776/v2/%(tenant_id)s'
#
# [*public_url_v3*]
#   (0ptional) The v3 endpoint's public url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8776/v3/%(tenant_id)s'
#
# [*internal_url_v3*]
#   (Optional) The v3 endpoint's internal url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8776/v3/%(tenant_id)s'
#
# [*admin_url_v3*]
#   (Optional) The v3 endpoint's admin url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8776/v3/%(tenant_id)s'
#
# === Examples
#
#  class { 'cinder::keystone::auth':
#    public_url   => 'https://10.0.0.10:8776/v3/%(tenant_id)s',
#    internal_url => 'https://10.0.0.20:8776/v3/%(tenant_id)s',
#    admin_url    => 'https://10.0.0.30:8776/v3/%(tenant_id)s',
#  }
#
# DEPRECATED PARAMETERS
#
# [*configure_endpoint*]
#   (Optional) Should Cinder v1 endpoint be configured?
#   API v1 was removed in Queens.
#   Defaults to undef
#
# [*public_url*]
#   (Optional) The endpoint's public url. (Defaults to 'http://127.0.0.1:8776/v1/%(tenant_id)s')
#   This url should *not* contain any trailing '/'.
#   Defaults to undef
#
# [*internal_url*]
#   (Optional) The endpoint's internal url.
#   This url should *not* contain any trailing '/'.
#   Defaults to undef
#
# [*admin_url*]
#   (Optional) The endpoint's admin url.
#   This url should *not* contain any trailing '/'.
#   Defaults to undef
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to undef
#
# [*service_type*]
#   (Optional) Type of service.
#   Defaults to undef
#
# [*service_description*]
#   (Optional) Description for keystone service.
#   Defaults to undef
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
  $public_url_v2          = 'http://127.0.0.1:8776/v2/%(tenant_id)s',
  $internal_url_v2        = 'http://127.0.0.1:8776/v2/%(tenant_id)s',
  $admin_url_v2           = 'http://127.0.0.1:8776/v2/%(tenant_id)s',
  $public_url_v3          = 'http://127.0.0.1:8776/v3/%(tenant_id)s',
  $internal_url_v3        = 'http://127.0.0.1:8776/v3/%(tenant_id)s',
  $admin_url_v3           = 'http://127.0.0.1:8776/v3/%(tenant_id)s',
  $configure_endpoint_v2  = true,
  $configure_endpoint_v3  = true,
  $configure_user         = true,
  $configure_user_v2      = false,
  $configure_user_v3      = false,
  $configure_user_role    = true,
  $configure_user_role_v2 = false,
  $configure_user_role_v3 = false,
  $service_name_v2        = 'cinderv2',
  $service_name_v3        = 'cinderv3',
  $service_type_v2        = 'volumev2',
  $service_type_v3        = 'volumev3',
  $service_description_v2 = 'Cinder Service v2',
  $service_description_v3 = 'Cinder Service v3',
  $region                 = 'RegionOne',
  # DEPRECATED PARAMETERS
  $configure_endpoint     = undef,
  $public_url             = undef,
  $internal_url           = undef,
  $admin_url              = undef,
  $service_name           = undef,
  $service_type           = undef,
  $service_description    = undef,
) {

  include ::cinder::deps

  $deprecated_param_names = [
    'configure_endpoint',
    'public_url',
    'internal_url',
    'admin_url',
    'service_name',
    'service_type',
    'service_description',
  ]
  $deprecated_param_names.each |$param_name| {
    $param = getvar($param_name)
    if $param != undef{
      warning("The ${param_name} parameter is deprecated, has no effect and will be removed in the future release.")
    }
  }

  if $configure_endpoint_v2 {
    Keystone_endpoint["${region}/${service_name_v2}::${service_type_v2}"] -> Anchor['cinder::service::end']
  }
  if $configure_endpoint_v3 {
    Keystone_endpoint["${region}/${service_name_v3}::${service_type_v3}"] -> Anchor['cinder::service::end']
  }

  # Always configure the original (non-v2|v3) user and user roles, as these
  # can be used by the v2 and v3 services.
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
