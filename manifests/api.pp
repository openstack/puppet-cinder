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
# [*service_workers*]
#   (optional) Number of cinder-api workers
#   Defaults to $::os_workers
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
# [*osapi_volume_listen_port*]
#   (optional) What port the API listens on. Defaults to $::os_service_default
#   If this value is modified the catalog URLs in the keystone::auth class
#   will also need to be changed to match.
#
# [*keymgr_backend*]
#   (optional) Key Manager service class.
#   Example of valid value: castellan.key_manager.barbican_key_manager.BarbicanKeyManager
#   Defaults to 'cinder.keymgr.conf_key_mgr.ConfKeyManager'.
#
# DEPRECATED PARAMETERS
#
# [*keymgr_api_class*]
#   (optional) Deprecated. Key Manager service class.
#   Example of valid value: castellan.key_manager.barbican_key_manager.BarbicanKeyManager
#   Defaults to undef.
#
# [*nova_catalog_admin_info*]
#   (optional) Same as nova_catalog_info, but for admin endpoint.
#   Defaults to 'compute:Compute Service:adminURL'
#
class cinder::api (
  $nova_catalog_info              = 'compute:Compute Service:publicURL',
  $os_region_name                 = $::os_service_default,
  $privileged_user                = false,
  $os_privileged_user_name        = $::os_service_default,
  $os_privileged_user_password    = $::os_service_default,
  $os_privileged_user_tenant      = $::os_service_default,
  $os_privileged_user_auth_url    = $::os_service_default,
  $keymgr_encryption_api_url      = $::os_service_default,
  $keymgr_encryption_auth_url     = $::os_service_default,
  $service_workers                = $::os_workers,
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
  $keymgr_backend                 = 'cinder.keymgr.conf_key_mgr.ConfKeyManager',
  # DEPRECATED PARAMETERS
  $keymgr_api_class               = undef,
  $nova_catalog_admin_info        = 'compute:Compute Service:adminURL',
) inherits cinder::params {

  include ::cinder::deps
  include ::cinder::params
  include ::cinder::policy

  validate_bool($manage_service)
  validate_bool($enabled)

  if $nova_catalog_admin_info {
    warning('The nova_catalog_admin_info parameter has been deprecated and will be removed in the future release.')
  }

  if $use_ssl {
    if is_service_default($cert_file) {
      fail('The cert_file parameter is required when use_ssl is set to true')
    }
    if is_service_default($key_file) {
      fail('The key_file parameter is required when use_ssl is set to true')
    }
  }

  if $keymgr_api_class {
    warning('The keymgr_api_class parameter is deprecated, use keymgr_backend')
    $keymgr_backend_real = $keymgr_api_class
  } else {
    $keymgr_backend_real = $keymgr_backend
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
    'DEFAULT/auth_strategy':            value => $auth_strategy;
  }

  cinder_config {
    'DEFAULT/nova_catalog_info':       value => $nova_catalog_info;
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
    'key_manager/backend':        value => $keymgr_backend_real;
    'barbican/barbican_endpoint': value => $keymgr_encryption_api_url;
    'barbican/auth_endpoint':     value => $keymgr_encryption_auth_url;
  }

  if $auth_strategy == 'keystone' {
    include ::cinder::keystone::authtoken
  }

  # SSL Options
  if $use_ssl {
    cinder_config {
      'ssl/cert_file' : value => $cert_file;
      'ssl/key_file' :  value => $key_file;
      'ssl/ca_file' :   value => $ca_file;
    }
  }

  if (!is_service_default($ratelimits)) {
    cinder_api_paste_ini {
      'filter:ratelimit/paste.filter_factory': value => $ratelimits_factory;
      'filter:ratelimit/limits':               value => $ratelimits;
    }
  }

  if $validate {
    $keystone_project_name = $::cinder::keystone::authtoken::project_name
    $keystone_username = $::cinder::keystone::authtoken::username
    $keystone_password = $::cinder::keystone::authtoken::password

    $validation_cmd = {
      'cinder-api' => {
        # lint:ignore:140chars
        'command'  => "cinder --os-auth-url ${::cinder::keystone::authtoken::www_authenticate_uri} --os-project-name ${keystone_project_name} --os-username ${keystone_username} --os-password ${keystone_password} list",
        # lint:endignore
      }
    }
    create_resources('openstacklib::service_validation', $validation_cmd, {'subscribe' => 'Service[cinder-api]'})
  }

}
