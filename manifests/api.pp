# == Class: cinder::api
#
# Setup and configure the cinder API endpoint
#
# === Parameters
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
# [*keymgr_api_class*]
#   (optional) Key Manager service class.
#   Example of valid value: castellan.key_manager.barbican_key_manager.BarbicanKeyManager
#   Defaults to $::os_service_default
#
# [*keymgr_encryption_api_url*]
#   (optional) Key Manager service URL
#   Example of valid value: https://localhost:9311/v1
#   Defaults to $::os_service_default
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
#   (optional) The state of the service (boolean value)
#   Defaults to true
#
# [*manage_service*]
#   (optional) Whether to start/stop the service (boolean value)
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
# [*service_name*]
#   (optional) Name of the service that will be providing the
#   server functionality of cinder-api.
#   If the value is 'httpd', this means cinder-api will be a web
#   service, and you must use another class to configure that
#   web service. For example, use class { 'cinder::wsgi::apache'...}
#   to make cinder-api be a web app using apache mod_wsgi.
#   Defaults to '$::cinder::params::api_service'
#
# [*enable_proxy_headers_parsing*]
#   (optional) This determines if the HTTPProxyToWSGI
#   middleware should parse the proxy headers or not.(boolean value)
#   Defaults to $::os_service_default
#
# [*use_ssl*]
#   (optional) Enable SSL on the API server
#   Defaults to false
#
# [*cert_file*]
#   (optional) Certificate file to use when starting API server securely
#   Defaults to $::os_service_default
#
# [*key_file*]
#   (optional) Private key file to use when starting API server securely
#   Defaults to $::os_service_default
#
# [*ca_file*]
#   (optional) CA certificate file to use to verify connecting clients
#   Defaults to $::os_service_default
#
# [*auth_strategy*]
#   (optional) Type of authentication to be used.
#   Defaults to 'keystone'
#
# DEPRECATED PARAMETERS
#
# [*keystone_enabled*]
#   (optional) Deprecated. Use auth_strategy instead.
#   Defaults to undef
#
# [*keystone_tenant*]
#   (optional) Deprecated. Use cinder::keystone::authtoken::project_name instead.
#   Defaults to undef.
#
# [*keystone_user*]
#   (optional) Deprecated. Use cinder::keystone::authtoken::username instead.
#   Defaults to undef.
#
# [*keystone_password*]
#   (optional) Deprecated. Use cinder::keystone::authtoken::password instead.
#   Defaults to undef.
#
# [*identity_uri*]
#   (optional) Deprecated. Use cinder::keystone::authtoken::auth_url instead.
#   Defaults to undef.
#
# [*auth_uri*]
#  (optional) Deprecated. Use cinder::keystone::authtoken::auth_uri instead.
#  Defaults to undef.
#
# [*memcached_servers*]
#  (Optional) Deprecated. Use cinder::keystone::authtoken::memcached_servers.
#  Defaults to undef.
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
# [*osapi_volume_listen_port*]
#   (optional) What port the API listens on. Defaults to $::os_service_default
#   If this value is modified the catalog URLs in the keystone::auth class
#   will also need to be changed to match.
#
class cinder::api (
  $keystone_enabled               = true,
  $nova_catalog_info              = 'compute:Compute Service:publicURL',
  $nova_catalog_admin_info        = 'compute:Compute Service:adminURL',
  $os_region_name                 = $::os_service_default,
  $privileged_user                = false,
  $os_privileged_user_name        = $::os_service_default,
  $os_privileged_user_password    = $::os_service_default,
  $os_privileged_user_tenant      = $::os_service_default,
  $os_privileged_user_auth_url    = $::os_service_default,
  $keymgr_api_class               = $::os_service_default,
  $keymgr_encryption_api_url      = $::os_service_default,
  $keymgr_encryption_auth_url     = $::os_service_default,
  $service_workers                = $::processorcount,
  $package_ensure                 = 'present',
  $bind_host                      = '0.0.0.0',
  $enabled                        = true,
  $manage_service                 = true,
  $ratelimits                     = $::os_service_default,
  $default_volume_type            = $::os_service_default,
  $ratelimits_factory =
    'cinder.api.v1.limits:RateLimitingMiddleware.factory',
  $validate                       = false,
  $sync_db                        = true,
  $public_endpoint                = $::os_service_default,
  $osapi_volume_base_url          = $::os_service_default,
  $osapi_max_limit                = $::os_service_default,
  $service_name                   = $::cinder::params::api_service,
  $enable_proxy_headers_parsing   = $::os_service_default,
  $use_ssl                        = false,
  $cert_file                      = $::os_service_default,
  $key_file                       = $::os_service_default,
  $ca_file                        = $::os_service_default,
  $auth_strategy                  = 'keystone',
  $osapi_volume_listen_port       = $::os_service_default,
  # DEPRECATED PARAMETERS
  $validation_options             = {},
  $keystone_tenant                = undef,
  $keystone_user                  = undef,
  $keystone_password              = undef,
  $identity_uri                   = undef,
  $auth_uri                       = undef,
  $memcached_servers              = undef,
) inherits cinder::params {

  include ::cinder::deps
  include ::cinder::params
  include ::cinder::policy

  validate_bool($manage_service)
  validate_bool($enabled)

  # Keep backwards compatibility with SSL values being set in init.pp
  $use_ssl_real = pick($::cinder::use_ssl, $use_ssl)
  $cert_file_real = pick($::cinder::cert_file, $cert_file)
  $key_file_real = pick($::cinder::key_file, $key_file)
  $ca_file_real = pick($::cinder::ca_file, $ca_file)

  if $identity_uri {
    warning('cinder::api::identity_uri is deprecated, use cinder::keystone::authtoken::auth_url instead.')
  }
  if $auth_uri {
    warning('cinder::api::auth_uri is deprecated, use cinder::keystone::authtoken::auth_uri instead.')
  }
  if $keystone_tenant {
    warning('cinder::api::keystone_tenant is deprecated, use cinder::keystone::authtoken::project_name instead.')
  }
  if $keystone_user {
    warning('cinder::api::keystone_user is deprecated, use cinder::keystone::authtoken::username instead.')
  }
  if $keystone_password {
    warning('cinder::api::keystone_password is deprecated, use cinder::keystone::authtoken::password instead.')
  }
  if $memcached_servers {
    warning('cinder::api::memcached_servers is deprecated, use cinder::keystone::authtoken::memcached_servers instead.')
  }

  if $keystone_enabled {
    warning('keystone_enabled is deprecated, use auth_strategy instead.')
    $auth_strategy_real = $keystone_enabled
  } else {
    $auth_strategy_real = $auth_strategy
  }

  if $use_ssl_real {
    if is_service_default($cert_file_real) {
      fail('The cert_file parameter is required when use_ssl is set to true')
    }
    if is_service_default($key_file_real) {
      fail('The key_file parameter is required when use_ssl is set to true')
    }
  }

  if $::cinder::params::api_package {
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

  if $service_name == $::cinder::params::api_service {
    service { 'cinder-api':
      ensure    => $ensure,
      name      => $::cinder::params::api_service,
      enable    => $enabled,
      hasstatus => true,
      tag       => 'cinder-service',
    }

  } elsif $service_name == 'httpd' {
    include ::apache::params
    service { 'cinder-api':
      ensure => 'stopped',
      name   => $::cinder::params::api_service,
      enable => false,
      tag    => ['cinder-service'],
    }

    # we need to make sure cinder-api/eventlet is stopped before trying to start apache
    Service['cinder-api'] -> Service[$service_name]
  } else {
    fail("Invalid service_name. Either cinder-api/openstack-cinder-api for \
running as a standalone service, or httpd for being run by a httpd server")
  }

  cinder_config {
    'DEFAULT/osapi_volume_listen':      value => $bind_host;
    'DEFAULT/osapi_volume_workers':     value => $service_workers;
    'DEFAULT/os_region_name':           value => $os_region_name;
    'DEFAULT/default_volume_type':      value => $default_volume_type;
    'DEFAULT/public_endpoint':          value => $public_endpoint;
    'DEFAULT/osapi_volume_base_URL':    value => $osapi_volume_base_url;
    'DEFAULT/osapi_max_limit':          value => $osapi_max_limit;
    'DEFAULT/osapi_volume_listen_port': value => $osapi_volume_listen_port;
  }

  cinder_config {
    'DEFAULT/nova_catalog_info':       value => $nova_catalog_info;
    'DEFAULT/nova_catalog_admin_info': value => $nova_catalog_admin_info;
  }

  oslo::middleware {'cinder_config':
    enable_proxy_headers_parsing => $enable_proxy_headers_parsing,
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
    'key_manager/api_class':      value => $keymgr_api_class;
    'barbican/barbican_endpoint': value => $keymgr_encryption_api_url;
    'barbican/auth_endpoint':     value => $keymgr_encryption_auth_url;
  }

  if $auth_strategy_real {
    include ::cinder::keystone::authtoken
  }

  # SSL Options
  if $use_ssl_real {
    cinder_config {
      'ssl/cert_file' : value => $cert_file_real;
      'ssl/key_file' :  value => $key_file_real;
      'ssl/ca_file' :   value => $ca_file_real;
    }
  }

  if (!is_service_default($ratelimits)) {
    cinder_api_paste_ini {
      'filter:ratelimit/paste.filter_factory': value => $ratelimits_factory;
      'filter:ratelimit/limits':               value => $ratelimits;
    }
  }

  if $validate {
    $keystone_tenant_real = pick($keystone_tenant, $::cinder::keystone::authtoken::project_name)
    $keystone_username_real = pick($keystone_user, $::cinder::keystone::authtoken::username)
    $keystone_password_real = pick($keystone_password, $::cinder::keystone::authtoken::password)

    $defaults = {
      'cinder-api' => {
        # lint:ignore:140chars
        'command'  => "cinder --os-auth-url ${::cinder::keystone::authtoken::auth_uri} --os-project-name ${keystone_tenant_real} --os-username ${keystone_username_real} --os-password ${keystone_password_real} list",
        # lint:endignore
      }
    }
    $validation_options_hash = merge ($defaults, $validation_options)
    create_resources('openstacklib::service_validation', $validation_options_hash, {'subscribe' => 'Service[cinder-api]'})
  }

}
