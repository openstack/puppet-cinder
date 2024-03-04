# == Class: cinder::api
#
# Setup and configure the cinder API endpoint
#
# === Parameters
#
# [*service_workers*]
#   (optional) Number of cinder-api workers
#   Defaults to $facts['os_workers']
#
# [*package_ensure*]
#   (optional) The state of the package
#   Defaults to present
#
# [*bind_host*]
#   (optional) The cinder api bind address
#   Defaults to $facts['os_service_default']
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
#   Defaults to $facts['os_service_default'].
#
# [*ratelimits_factory*]
#   (optional) Factory to use for ratelimiting
#   Defaults to 'cinder.api.v2.limits:RateLimitingMiddleware.factory'
#
# [*default_volume_type*]
#   (optional) default volume type to use.
#   This should contain the name of the default volume type to use.
#   If not configured, it produces an error when creating a volume
#   without specifying a type.
#   Defaults to $facts['os_service_default'].
#
# [*sync_db*]
#   (Optional) Run db sync on the node.
#   Defaults to true
#
# [*public_endpoint*]
#   (Optional) Public url to use for versions endpoint.
#   Defaults to $facts['os_service_default']
#
# [*osapi_volume_base_url*]
#   (Optional) Base URL that will be presented to users in links to the OpenStack Volume API.
#   Defaults to $facts['os_service_default']
#
# [*osapi_max_limit*]
#   (Optional) The maximum number of items that a collection resource
#   returns in a single response (integer value)
#   Defaults to $facts['os_service_default']
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
#   Defaults to $facts['os_service_default']
#
# [*max_request_body_size*]
#   (Optional) Set max request body size
#   Defaults to $facts['os_service_default'].
#
# [*use_ssl*]
#   (optional) Enable SSL on the API server
#   Defaults to false
#
# [*cert_file*]
#   (optional) Certificate file to use when starting API server securely
#   Defaults to $facts['os_service_default']
#
# [*key_file*]
#   (optional) Private key file to use when starting API server securely
#   Defaults to $facts['os_service_default']
#
# [*ca_file*]
#   (optional) CA certificate file to use to verify connecting clients
#   Defaults to $facts['os_service_default']
#
# [*auth_strategy*]
#   (optional) Type of authentication to be used.
#   Defaults to 'keystone'
#
# [*osapi_volume_listen_port*]
#   (optional) What port the API listens on. If this value is modified
#   the catalog URLs in the keystone::auth class will also need to be changed
#   to match.
#   Defaults to $facts['os_service_default']
#
# [*use_forwarded_for*]
#   (optional) Treat X-Forwarded-For as the canonical remote address. Only
#   enable this if you have a sanitizing proxy.
#   Defaults to $facts['os_service_default']
#
class cinder::api (
  $service_workers                = $facts['os_workers'],
  $package_ensure                 = 'present',
  $bind_host                      = $facts['os_service_default'],
  Boolean $enabled                = true,
  Boolean $manage_service         = true,
  $ratelimits                     = $facts['os_service_default'],
  $default_volume_type            = $facts['os_service_default'],
  $ratelimits_factory =
    'cinder.api.v2.limits:RateLimitingMiddleware.factory',
  Boolean $sync_db                = true,
  $public_endpoint                = $facts['os_service_default'],
  $osapi_volume_base_url          = $facts['os_service_default'],
  $osapi_max_limit                = $facts['os_service_default'],
  $service_name                   = $::cinder::params::api_service,
  $enable_proxy_headers_parsing   = $facts['os_service_default'],
  $max_request_body_size          = $facts['os_service_default'],
  Boolean $use_ssl                = false,
  $cert_file                      = $facts['os_service_default'],
  $key_file                       = $facts['os_service_default'],
  $ca_file                        = $facts['os_service_default'],
  $auth_strategy                  = 'keystone',
  $osapi_volume_listen_port       = $facts['os_service_default'],
  $use_forwarded_for              = $facts['os_service_default'],
) inherits cinder::params {

  include cinder::deps
  include cinder::params
  include cinder::policy

  if $use_ssl {
    if is_service_default($cert_file) {
      fail('The cert_file parameter is required when use_ssl is set to true')
    }
    if is_service_default($key_file) {
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
    include cinder::db::sync
  }

  if $manage_service {
    if $enabled {
      $ensure = 'running'
    } else {
      $ensure = 'stopped'
    }

    if $service_name == $::cinder::params::api_service {
      service { 'cinder-api':
        ensure    => $ensure,
        name      => $::cinder::params::api_service,
        enable    => $enabled,
        hasstatus => true,
        tag       => 'cinder-service',
      }

      # On any api-paste.ini config change, we must restart Cinder API.
      Cinder_api_paste_ini<||> ~> Service['cinder-api']
      # On any uwsgi config change, we must restart Cinder API.
      Cinder_api_uwsgi_config<||> ~> Service['cinder-api']

    } elsif $service_name == 'httpd' {
      service { 'cinder-api':
        ensure => 'stopped',
        name   => $::cinder::params::api_service,
        enable => false,
        tag    => ['cinder-service'],
      }
      Service <| title == 'httpd' |> { tag +> 'cinder-service' }

      # we need to make sure cinder-api/eventlet is stopped before trying to start apache
      Service['cinder-api'] -> Service[$service_name]

      # On any api-paste.ini config change, we must restart Cinder API.
      Cinder_api_paste_ini<||> ~> Service[$service_name]

    } else {
      fail("Invalid service_name. Either cinder-api/openstack-cinder-api for \
running as a standalone service, or httpd for being run by a httpd server")
    }
  }

  cinder_config {
    'DEFAULT/osapi_volume_listen':      value => $bind_host;
    'DEFAULT/osapi_volume_workers':     value => $service_workers;
    'DEFAULT/default_volume_type':      value => $default_volume_type;
    'DEFAULT/public_endpoint':          value => $public_endpoint;
    'DEFAULT/osapi_volume_base_URL':    value => $osapi_volume_base_url;
    'DEFAULT/osapi_max_limit':          value => $osapi_max_limit;
    'DEFAULT/osapi_volume_listen_port': value => $osapi_volume_listen_port;
    'DEFAULT/auth_strategy':            value => $auth_strategy;
    'DEFAULT/use_forwarded_for':        value => $use_forwarded_for;
  }

  oslo::middleware {'cinder_config':
    enable_proxy_headers_parsing => $enable_proxy_headers_parsing,
    max_request_body_size        => $max_request_body_size,
  }

  if $auth_strategy == 'keystone' {
    include cinder::keystone::authtoken
  }

  # SSL Options
  if $use_ssl {
    cinder_config {
      'ssl/cert_file' : value => $cert_file;
      'ssl/key_file' :  value => $key_file;
      'ssl/ca_file' :   value => $ca_file;
    }
  } else {
    cinder_config {
      'ssl/cert_file' : value => $facts['os_service_default'];
      'ssl/key_file' :  value => $facts['os_service_default'];
      'ssl/ca_file' :   value => $facts['os_service_default'];
    }
  }

  if (!is_service_default($ratelimits)) {
    cinder_api_paste_ini {
      'filter:ratelimit/paste.filter_factory': value => $ratelimits_factory;
      'filter:ratelimit/limits':               value => $ratelimits;
    }
  }
}
