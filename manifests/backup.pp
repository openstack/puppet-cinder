# == Class: cinder::backup
#
# Setup Cinder backup service
#
# === Parameters
#
# [*enabled*]
#   (Optional) Should the service be enabled (boolean value)
#   Defaults to true.
#
# [*manage_service*]
#   (Optional) Whether to start/stop the service (boolean value)
#   Defaults to true.
#
# [*package_ensure*]
#   (Optional) Ensure state for package.
#   Defaults to 'present'.
#
# [*backup_topic*]
#   (optional) The topic volume backup nodes listen on.
#   Defaults to $::os_service_default
#
# [*backup_manager*]
#   (optional) Full class name for the Manager for volume backup.
#   Defaults to $::os_service_default
#
# [*backup_api_class*]
#   (optional) The full class name of the volume backup API class.
#   Defaults to $::os_service_default
#
# [*backup_name_template*]
#   (optional) Template string to be used to generate backup names.
#   Defaults to $::os_service_default
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
class cinder::backup (
  $enabled              = true,
  $manage_service       = true,
  $package_ensure       = 'present',
  $backup_topic         = $::os_service_default,
  $backup_manager       = $::os_service_default,
  $backup_api_class     = $::os_service_default,
  $backup_name_template = $::os_service_default,
) {

  include ::cinder::deps
  include ::cinder::params

  validate_bool($manage_service)
  validate_bool($enabled)

  if $::cinder::params::backup_package {
    package { 'cinder-backup':
      ensure => $package_ensure,
      name   => $::cinder::params::backup_package,
      tag    => ['openstack', 'cinder-package'],
    }
  }

  if $manage_service {
    if $enabled {
      $ensure = 'running'
    } else {
      $ensure = 'stopped'
    }
  }

  service { 'cinder-backup':
    ensure    => $ensure,
    name      => $::cinder::params::backup_service,
    enable    => $enabled,
    hasstatus => true,
    tag       => 'cinder-service',
  }

  cinder_config {
    'DEFAULT/backup_topic':         value => $backup_topic;
    'DEFAULT/backup_manager':       value => $backup_manager;
    'DEFAULT/backup_api_class':     value => $backup_api_class;
    'DEFAULT/backup_name_template': value => $backup_name_template;
  }

}
