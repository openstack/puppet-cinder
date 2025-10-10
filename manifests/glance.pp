# == Class: cinder::glance
#
# Glance drive Cinder as a block storage backend to store image data.
#
# === Parameters
#
# [*glance_api_servers*]
#   (optional) A list of the glance api servers available to cinder.
#   Should be an array with [hostname|ip]:port
#   Defaults to $facts['os_service_default']
#
# [*glance_num_retries*]
#   (optional) Number retries when downloading an image from glance.
#   Defaults to $facts['os_service_default']
#
# [*glance_api_insecure*]
#   (optional) Allow to perform insecure SSL (https) requests to glance.
#   Defaults to $facts['os_service_default']
#
# [*glance_api_ssl_compression*]
#   (optional) Whether to attempt to negotiate SSL layer compression when
#   using SSL (https) requests. Set to False to disable SSL
#   layer compression. In some cases disabling this may improve
#   data throughput, eg when high network bandwidth is available
#   and you are using already compressed image formats such as qcow2.
#   Defaults to $facts['os_service_default']
#
# [*glance_request_timeout*]
#   (optional) http/https timeout value for glance operations.
#   Defaults to $facts['os_service_default']
#
# [*allowed_direct_url_schemes*]
#   (optional) A list of url schemes that can be downloaded directly via
#   direct_url.
#   Defaults to $facts['os_service_default']
#
# [*verify_glance_signatures*]
#   (optional) Enable image signature verification.
#   Defaults to $facts['os_service_default']
#
# [*glance_catalog_info*]
#   (optional) Info to match when looking for glance in the service catalog.
#   Only used if glance_api_servers are not provided.
#   Defaults to $facts['os_service_default']
#
# [*glance_core_properties*]
#   (optional) Default core properties of image
#   Defaults to $facts['os_service_default']
#
# [*cafile*]
#   (optional) PEM encoded Certificate Authority to use
#   when verifying HTTPs connections.
#   Defaults to $facts['os_service_default']
#
# [*certfile*]
#   (optional) PEM encoded client certificate cert file.
#   Defaults to $facts['os_service_default']
#
# [*keyfile*]
#   (optional) PEM encoded client certificate key file.
#   Defaults to $facts['os_service_default']
#
# [*insecure*]
#   (optional) Verify HTTPS connections.
#   Defaults to $facts['os_service_default']
#
# [*timeout*]
#   (optional) Timeout value for http requests.
#   Defaults to $facts['os_service_default']
#
# [*collect_timing*]
#   (optional) Collect per-API call timing information.
#   Defaults to $facts['os_service_default']
#
# [*split_loggers*]
#   (optional) Log requests to multiple loggers.
#   Defaults to $facts['os_service_default']
#
# [*auth_type*]
#   (optional) Authentication type to load.
#   Defaults to undef
#
# [*auth_url*]
#   (optional) Identity service url.
#   Defaults to 'http://127.0.0.1:5000'
#
# [*username*]
#   (optional) Glance admin username.
#   Defaults to 'glance'
#
# [*password*]
#   (optional) Nova admin password.
#   Defaults to $facts['os_service_default']
#
# [*user_domain_name*]
#   (optional) Glance admin user domain name.
#   Defaults to 'Default'
#
# [*project_name*]
#   (optional) Glance admin project name.
#   Defaults to 'services'
#
# [*project_domain_name*]
#   (optional) Glance admin project domain name.
#   Defaults to 'Default'
#
# [*system_scope*]
#   (optional) Scope for system operations
#   Defaults to $facts['os_service_default']
#
# === Author(s)
#
# Emilien Macchi <emilien.macchi@enovance.com>
#
# === Copyright
#
# Copyright (C) 2013 eNovance SAS <licensing@enovance.com>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
class cinder::glance (
  $glance_api_servers         = $facts['os_service_default'],
  $glance_num_retries         = $facts['os_service_default'],
  $glance_api_insecure        = $facts['os_service_default'],
  $glance_api_ssl_compression = $facts['os_service_default'],
  $glance_request_timeout     = $facts['os_service_default'],
  $allowed_direct_url_schemes = $facts['os_service_default'],
  $verify_glance_signatures   = $facts['os_service_default'],
  $glance_catalog_info        = $facts['os_service_default'],
  $glance_core_properties     = $facts['os_service_default'],
  $cafile                     = $facts['os_service_default'],
  $certfile                   = $facts['os_service_default'],
  $keyfile                    = $facts['os_service_default'],
  $insecure                   = $facts['os_service_default'],
  $timeout                    = $facts['os_service_default'],
  $collect_timing             = $facts['os_service_default'],
  $split_loggers              = $facts['os_service_default'],
  $auth_type                  = undef,
  $auth_url                   = 'http://127.0.0.1:5000',
  $username                   = 'glance',
  $password                   = $facts['os_service_default'],
  $user_domain_name           = 'Default',
  $project_name               = 'services',
  $project_domain_name        = 'Default',
  $system_scope               = $facts['os_service_default'],
) {
  include cinder::deps

  if $auth_type == undef {
    warning("The auth_type parameter will defaults to 'password' in a future release. \
Make sure parameters such as password are properly set.")
    $auth_type_real = $facts['os_service_default']
  } else {
    $auth_type_real = $auth_type
  }

  cinder_config {
    'DEFAULT/glance_api_servers':         value => join(any2array($glance_api_servers), ',');
    'DEFAULT/glance_num_retries':         value => $glance_num_retries;
    'DEFAULT/glance_api_insecure':        value => $glance_api_insecure;
    'DEFAULT/glance_api_ssl_compression': value => $glance_api_ssl_compression;
    'DEFAULT/glance_request_timeout':     value => $glance_request_timeout;
    'DEFAULT/allowed_direct_url_schemes': value => join(any2array($allowed_direct_url_schemes), ',');
    'DEFAULT/verify_glance_signatures':   value => $verify_glance_signatures;
    'DEFAULT/glance_catalog_info':        value => $glance_catalog_info;
    'DEFAULT/glance_core_properties':     value => join(any2array($glance_core_properties), ',');
  }

  if is_service_default($system_scope) {
    $project_name_real = $project_name
    $project_domain_name_real = $project_domain_name
  } else {
    $project_name_real = $facts['os_service_default']
    $project_domain_name_real = $facts['os_service_default']
  }

  cinder_config {
    'glance/cafile':              value => $cafile;
    'glance/certfile':            value => $certfile;
    'glance/keyfile':             value => $keyfile;
    'glance/insecure':            value => $insecure;
    'glance/timeout':             value => $timeout;
    'glance/collect_timing':      value => $collect_timing;
    'glance/split_loggers':       value => $split_loggers;
    'glance/auth_type':           value => $auth_type_real;
    'glance/auth_url':            value => $auth_url;
    'glance/username':            value => $username;
    'glance/user_domain_name':    value => $user_domain_name;
    'glance/password':            value => $password, secret => true;
    'glance/project_name':        value => $project_name_real;
    'glance/project_domain_name': value => $project_domain_name_real;
    'glance/system_scope':        value => $system_scope;
  }
}
