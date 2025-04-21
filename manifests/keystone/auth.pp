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
# [*auth_name*]
#   (Optional) Username for Cinder service.
#   Defaults to 'cinder'.
#
# [*configure_endpoint*]
#   (Optional) Should Cinder endpoint be configured?
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
# [*configure_user_role*]
#   (Optional) Should the admin role be configured for the service user?
#   Defaults to true
#
# [*configure_service*]
#   (Optional) Should the service be configured?
#   Defaults to True
#
# [*configure_service_v3*]
#   (Optional) Should the v3 service be configured?
#   Defaults to True
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to 'cinder'.
#
# [*service_name_v3*]
#   (Optional) Name of the v3 service.
#   Defaults to 'cinderv3'.
#
# [*service_type*]
#   (Optional) Type of the service.
#   Defaults to 'block-storage'.
#
# [*service_type_v3*]
#   (Optional) Type of the v3 service.
#   Defaults to 'volumev3'.
#
# [*service_description*]
#   (Optional) Description for the service.
#   Defaults to 'OpenStack Block Storage Service'.
#
# [*service_description_v3*]
#   (Optional) Description for the v3 service.
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
# [*roles*]
#   (Optional) List of roles assigned to Cinder user
#   Defaults to ['admin']
#
# [*system_scope*]
#   (Optional) Scope for system operations used by Cinder v3 user.
#   Defaults to 'all'
#
# [*system_roles*]
#   (Optional) List of system roles assigned to Cinder user.
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
  String[1] $password,
  String[1] $auth_name                       = 'cinder',
  String[1] $tenant                          = 'services',
  Array[String[1]] $roles                    = ['admin'],
  String[1] $system_scope                    = 'all',
  Array[String[1]] $system_roles             = [],
  String[1] $email                           = 'cinder@localhost',
  Keystone::PublicEndpointUrl $public_url_v3 = 'http://127.0.0.1:8776/v3',
  Keystone::EndpointUrl $internal_url_v3     = 'http://127.0.0.1:8776/v3',
  Keystone::EndpointUrl $admin_url_v3        = 'http://127.0.0.1:8776/v3',
  Boolean $configure_endpoint                = true,
  Boolean $configure_endpoint_v3             = true,
  Boolean $configure_user                    = true,
  Boolean $configure_user_role               = true,
  Boolean $configure_service                 = true,
  Boolean $configure_service_v3              = true,
  String[1] $service_name                    = 'cinder',
  String[1] $service_name_v3                 = 'cinderv3',
  String[1] $service_type                    = 'block-storage',
  String[1] $service_type_v3                 = 'volumev3',
  String[1] $service_description             = 'OpenStack Block Storage Service',
  String[1] $service_description_v3          = 'Cinder Service v3',
  String[1] $region                          = 'RegionOne',
) {

  include cinder::deps

  Keystone::Resource::Service_identity['cinder'] -> Anchor['cinder::service::end']
  Keystone::Resource::Service_identity['cinderv3'] -> Anchor['cinder::service::end']

  keystone::resource::service_identity { 'cinder':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    configure_service   => $configure_service,
    service_type        => $service_type,
    service_description => $service_description,
    service_name        => $service_name,
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    roles               => $roles,
    system_scope        => $system_scope,
    system_roles        => $system_roles,
    public_url          => $public_url_v3,
    admin_url           => $admin_url_v3,
    internal_url        => $internal_url_v3,
  }

  keystone::resource::service_identity { 'cinderv3':
    configure_user      => false,
    configure_user_role => false,
    configure_endpoint  => $configure_endpoint_v3,
    configure_service   => $configure_service_v3,
    service_type        => $service_type_v3,
    service_description => $service_description_v3,
    service_name        => $service_name_v3,
    region              => $region,
    public_url          => $public_url_v3,
    admin_url           => $admin_url_v3,
    internal_url        => $internal_url_v3,
  }

}
