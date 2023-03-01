# == Class: cinder::backup::swift
#
# Setup Cinder to backup volumes into Swift
#
# === Parameters
#
# [*backup_driver*]
#   (Optional) The backup driver for Swift back-end.
#   Defaults to 'cinder.backup.drivers.swift.SwiftBackupDriver'.
#
# [*backup_swift_url*]
#   (optional) The URL of the Swift endpoint.
#   Should be a valid Swift URL
#   Defaults to $facts['os_service_default']
#
# [*backup_swift_auth_url*]
#   (optional) The URL of the Keystone endpoint for authentication.
#   Defaults to $facts['os_service_default']
#
# [*swift_catalog_info*]
#   (optional) Info to match when looking for swift in the service catalog
#   Defaults to $facts['os_service_default']
#
# [*backup_swift_container*]
#   (optional) The default Swift container to use.
#   Defaults to 'volumebackups'
#
# [*backup_swift_create_storage_policy*]
#   (optional) The storage policy to use when creating the Swift container.
#   Defaults to $facts['os_service_default']
#
# [*backup_swift_object_size*]
#   (optional) The size in bytes of Swift backup objects.
#   Defaults to $facts['os_service_default']
#
# [*backup_swift_retry_attempts*]
#   (optional) The number of retries to make for Swift operations.
#   Defaults to $facts['os_service_default']
#
# [*backup_swift_retry_backoff*]
#   (optional) The backoff time in seconds between Swift retries.
#   Defaults to $facts['os_service_default']
#
# [*backup_swift_user_domain*]
#  (optional) Swift user domain name. Required when connecting to an
#  auth 3.0 system.
#  Defaults to $facts['os_service_default']
#
# [*backup_swift_project_domain*]
#  (optional) Swift project domain name. Required when connecting to an
#  auth 3.0 system.
#  Defaults to $facts['os_service_default']
#
# [*backup_swift_project*]
#  (optional) Swift project/account name. Required when connection to an
#  auth 3.0 system.
#  Defaults to $facts['os_service_default']
#
# [*backup_compression_algorithm*]
#   (optional) The compression algorithm for the chunks sent to swift
#   Defaults to $facts['os_service_default']
#   set to None to disable compression
#
# [*backup_swift_service_auth*]
#   (optional) Send a X-Service-Token header with service auth credentials.
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
#
class cinder::backup::swift (
  $backup_driver                      = 'cinder.backup.drivers.swift.SwiftBackupDriver',
  $backup_swift_url                   = $facts['os_service_default'],
  $backup_swift_auth_url              = $facts['os_service_default'],
  $swift_catalog_info                 = $facts['os_service_default'],
  $backup_swift_container             = 'volumebackups',
  $backup_swift_create_storage_policy = $facts['os_service_default'],
  $backup_swift_object_size           = $facts['os_service_default'],
  $backup_swift_retry_attempts        = $facts['os_service_default'],
  $backup_swift_retry_backoff         = $facts['os_service_default'],
  $backup_swift_user_domain           = $facts['os_service_default'],
  $backup_swift_project_domain        = $facts['os_service_default'],
  $backup_swift_project               = $facts['os_service_default'],
  $backup_compression_algorithm       = $facts['os_service_default'],
  $backup_swift_service_auth          = $facts['os_service_default'],
) {

  include cinder::deps

  cinder_config {
    'DEFAULT/backup_driver':                      value => $backup_driver;
    'DEFAULT/backup_swift_url':                   value => $backup_swift_url;
    'DEFAULT/backup_swift_auth_url':              value => $backup_swift_auth_url;
    'DEFAULT/swift_catalog_info':                 value => $swift_catalog_info;
    'DEFAULT/backup_swift_container':             value => $backup_swift_container;
    'DEFAULT/backup_swift_create_storage_policy': value => $backup_swift_create_storage_policy;
    'DEFAULT/backup_swift_object_size':           value => $backup_swift_object_size;
    'DEFAULT/backup_swift_retry_attempts':        value => $backup_swift_retry_attempts;
    'DEFAULT/backup_swift_retry_backoff':         value => $backup_swift_retry_backoff;
    'DEFAULT/backup_swift_user_domain':           value => $backup_swift_user_domain;
    'DEFAULT/backup_swift_project_domain':        value => $backup_swift_project_domain;
    'DEFAULT/backup_swift_project':               value => $backup_swift_project;
    'DEFAULT/backup_compression_algorithm':       value => $backup_compression_algorithm;
    'DEFAULT/backup_swift_service_auth':          value => $backup_swift_service_auth;
  }

}
