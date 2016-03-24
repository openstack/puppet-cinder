# == Class: cinder::api
#
# Setup and configure the cinder API endpoint
#
# === Parameters
#
# [*keystone_password*]
#   The password to use for authentication (keystone)
#
# [*keystone_enabled*]
#   (optional) Use keystone for authentification
#   Defaults to true
#
# [*keystone_tenant*]
#   (optional) The tenant of the auth user
#   Defaults to services
#
# [*keystone_user*]
#   (optional) The name of the auth user
#   Defaults to cinder
#
# [*privileged_user*]
#   (optional) Enables OpenStack privileged account.
#   Defaults to false.
#
# [*os_privileged_user_name*]
#   (optional) OpenStack privileged account username. Used for requests to
#   other services (such as Nova) that require an account with
#   special rights.
#   Defaults to $::os_service_default.
#
# [*os_privileged_user_password*]
#   (optional) Password associated with the OpenStack privileged account.
#   Defaults to $::os_service_default.
#
# [*os_privileged_user_tenant*]
#   (optional) Tenant name associated with the OpenStack privileged account.
#   Defaults to $::os_service_default.
#
# [*os_privileged_user_auth_url*]
#   (optional) Auth URL associated with the OpenStack privileged account.
#   Defaults to $::os_service_default.
#
# [*keymgr_encryption_auth_url*]
#   (optional) Auth URL for keymgr authentication. Should be in format
#   http://auth_url:5000/v3
#   Defaults to $::os_service_default.
#
# [*os_region_name*]
#   (optional) Some operations require cinder to make API requests
#   to Nova. This sets the keystone region to be used for these
#   requests. For example, boot-from-volume.
#   Defaults to $::os_service_default
#
# [*nova_catalog_info*]
#   (optional) Match this value when searching for nova in the service
#   catalog.
#   Defaults to 'compute:Compute Service:publicURL'
#
# [*nova_catalog_admin_info*]
#   (optional) Same as nova_catalog_info, but for admin endpoint.
#   Defaults to 'compute:Compute Service:adminURL'
#
# [*auth_uri*]
#   (optional) Public Identity API endpoint.
#   Defaults to 'http://localhost:5000/'.
#
# [*identity_uri*]
#   (optional) Complete admin Identity API endpoint.
#   Defaults to: 'http://localhost:35357/'.
#
# [*service_workers*]
#   (optional) Number of cinder-api workers
#   Defaults to $::processorcount
#
# [*package_ensure*]
#   (optional) The state of the package
#   Defaults to present
#
# [*bind_host*]
#   (optional) The cinder api bind address
#   Defaults to 0.0.0.0
#
# [*enabled*]
#   (optional) The state of the service
#   Defaults to true
#
# [*manage_service*]
#   (optional) Whether to start/stop the service
#   Defaults to true
#
# [*ratelimits*]
#   (optional) The state of the service
#   Defaults to $::os_service_default. If undefined the default ratelimiting values are used.
#
# [*ratelimits_factory*]
#   (optional) Factory to use for ratelimiting
#   Defaults to 'cinder.api.v1.limits:RateLimitingMiddleware.factory'
#
# [*default_volume_type*]
#   (optional) default volume type to use.
#   This should contain the name of the default volume type to use.
#   If not configured, it produces an error when creating a volume
#   without specifying a type.
#   Defaults to $::os_service_default.
#
# [*validate*]
#   (optional) Whether to validate the service is working after any service refreshes
#   Defaults to false
#
# [*validation_options*]
#   (optional) Service validation options
#   Should be a hash of options defined in openstacklib::service_validation
#   If empty, defaults values are taken from openstacklib function.
#   Default command list volumes.
#   Require validate set at True.
#   Example:
#   glance::api::validation_options:
#     glance-api:
#       command: check_cinder-api.py
#       path: /usr/bin:/bin:/usr/sbin:/sbin
#       provider: shell
#       tries: 5
#       try_sleep: 10
#   Defaults to {}
#
# [*sync_db*]
#   (Optional) Run db sync on the node.
#   Defaults to true
#
# [*public_endpoint*]
#   (Optional) Public url to use for versions endpoint.
#   Defaults to $::os_service_default
#
# [*osapi_volume_base_url*]
#   (Optional) Base URL that will be presented to users in links to the OpenStack Volume API.
#   Defaults to $::os_service_default
#
# [*osapi_max_limit*]
#   (Optional) The maximum number of items that a collection resource
#   returns in a single response (integer value)
#   Defaults to $::os_service_default
#
class cinder::api (
  $keystone_password,
  $keystone_enabled            = true,
  $keystone_tenant             = 'services',
  $keystone_user               = 'cinder',
  $auth_uri                    = 'http://localhost:5000/',
  $identity_uri                = 'http://localhost:35357/',
  $nova_catalog_info           = 'compute:Compute Service:publicURL',
  $nova_catalog_admin_info     = 'compute:Compute Service:adminURL',
  $os_region_name              = $::os_service_default,
  $privileged_user             = false,
  $os_privileged_user_name     = $::os_service_default,
  $os_privileged_user_password = $::os_service_default,
  $os_privileged_user_tenant   = $::os_service_default,
  $os_privileged_user_auth_url = $::os_service_default,
  $keymgr_encryption_auth_url  = $::os_service_default,
  $service_workers             = $::processorcount,
  $package_ensure              = 'present',
  $bind_host                   = '0.0.0.0',
  $enabled                     = true,
  $manage_service              = true,
  $ratelimits                  = $::os_service_default,
  $default_volume_type         = $::os_service_default,
  $ratelimits_factory =
    'cinder.api.v1.limits:RateLimitingMiddleware.factory',
  $validate                   = false,
  $sync_db                    = true,
  $public_endpoint            = $::os_service_default,
  $osapi_volume_base_url      = $::os_service_default,
  $osapi_max_limit            = $::os_service_default,
  # DEPRECATED PARAMETERS
  $validation_options         = {},
) {

  include ::cinder::params
  include ::cinder::policy

  Cinder_config<||> ~> Service['cinder-api']
  Cinder_api_paste_ini<||> ~> Service['cinder-api']
  Class['cinder::policy'] ~> Service['cinder-api']

  if $::cinder::params::api_package {
    Package['cinder-api'] -> Class['cinder::policy']
    Package['cinder-api'] -> Service['cinder-api']
    Package['cinder-api'] ~> Exec<| title == 'cinder-manage db_sync' |>
    package { 'cinder-api':
      ensure => $package_ensure,
      name   => $::cinder::params::api_package,
      tag    => ['openstack', 'cinder-package'],
    }
  }

  if $sync_db {
    include ::cinder::db::sync
  }

  if $enabled {
    if $manage_service {
      $ensure = 'running'
    }
  } else {
    if $manage_service {
      $ensure = 'stopped'
    }
  }

  service { 'cinder-api':
    ensure    => $ensure,
    name      => $::cinder::params::api_service,
    enable    => $enabled,
    hasstatus => true,
    require   => Package['cinder'],
    tag       => 'cinder-service',
  }

  cinder_config {
    'DEFAULT/osapi_volume_listen':   value => $bind_host;
    'DEFAULT/osapi_volume_workers':  value => $service_workers;
    'DEFAULT/os_region_name':        value => $os_region_name;
    'DEFAULT/default_volume_type':   value => $default_volume_type;
    'DEFAULT/public_endpoint':       value => $public_endpoint;
    'DEFAULT/osapi_volume_base_URL': value => $osapi_volume_base_url;
    'DEFAULT/osapi_max_limit':       value => $osapi_max_limit;
  }

  cinder_config {
    'DEFAULT/nova_catalog_info':       value => $nova_catalog_info;
    'DEFAULT/nova_catalog_admin_info': value => $nova_catalog_admin_info;
  }

  if $privileged_user {
    if is_service_default($os_privileged_user_name) {
      fail('The os_privileged_user_name parameter is required when privileged_user is set to true')
    }
    if is_service_default($os_privileged_user_password) {
      fail('The os_privileged_user_password parameter is required when privileged_user is set to true')
    }
    if is_service_default($os_privileged_user_tenant) {
      fail('The os_privileged_user_tenant parameter is required when privileged_user is set to true')
    }
  }

  cinder_config {
    'DEFAULT/os_privileged_user_password': value => $os_privileged_user_password;
    'DEFAULT/os_privileged_user_tenant':   value => $os_privileged_user_tenant;
    'DEFAULT/os_privileged_user_name':     value => $os_privileged_user_name;
    'DEFAULT/os_privileged_user_auth_url': value => $os_privileged_user_auth_url;
  }

  cinder_config {
    'keystone_authtoken/auth_uri'     : value => $auth_uri;
    'keystone_authtoken/identity_uri' : value => $identity_uri;
    'keymgr/encryption_auth_url'      : value => $keymgr_encryption_auth_url;
  }

  if $keystone_enabled {
    cinder_config {
      'DEFAULT/auth_strategy':                value => 'keystone' ;
      'keystone_authtoken/admin_tenant_name': value => $keystone_tenant;
      'keystone_authtoken/admin_user':        value => $keystone_user;
      'keystone_authtoken/admin_password':    value => $keystone_password, secret => true;
    }
  }

  if (!is_service_default($ratelimits)) {
    cinder_api_paste_ini {
      'filter:ratelimit/paste.filter_factory': value => $ratelimits_factory;
      'filter:ratelimit/limits':               value => $ratelimits;
    }
  }

  if $validate {
    $defaults = {
      'cinder-api' => {
        'command'  => "cinder --os-auth-url ${auth_uri} --os-tenant-name ${keystone_tenant} --os-username ${keystone_user} --os-password ${keystone_password} list",
      }
    }
    $validation_options_hash = merge ($defaults, $validation_options)
    create_resources('openstacklib::service_validation', $validation_options_hash, {'subscribe' => 'Service[cinder-api]'})
  }

}
