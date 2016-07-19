# == Class: cinder::backup::posix
#
# Setup Cinder to backup volumes into a posix filesystem
#
# === Parameters
#
# [*backup_driver*]
#   (Optional) The backup driver for posix backend.
#   Defaults to 'cinder.backup.drivers.posix'.
#
# [*backup_file_size*]
#   (optional) The maximum size in bytes of the files used to hold backups.
#   If the volume being backed up exceeds this size, then it will be backed
#   up into multiple files. backup_file_size must be a multiple of
#   backup_sha_block_size_bytes.
#   Defaults to $::os_service_default
#
# [*backup_sha_block_size_bytes*]
#   (optional) The size in bytes that changes are tracked for incremental
#   backups. backup_file_size has to be a multiple of backup_sha_block_size_bytes.
#   Defaults to $::os_service_default
#
# [*backup_enable_progress_timer*]
#   (optional) Enable or Disable the timer to send the periodic progress
#   notifications to Ceilometer when backing up the volume to the backend
#   storage.
#   Defaults to $::os_service_default
#
# [*backup_posix_path*]
#   (optional) Path specifying where to store backups.
#   Defaults to $::os_service_default
#
# [*backup_container*]
#   (optional) Custom directory to use for backups.
#   Defaults to $::os_service_default
#
# === Author(s)
#
# Nate Potter <nathaniel.potter@intel.com>
#
# === Copyright
#
# Copyright (C) 2016 Intel
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
class cinder::backup::posix (
  $backup_driver               = 'cinder.backup.drivers.posix',
  $backup_file_size            = $::os_service_default,
  $backup_sha_block_size_bytes = $::os_service_default,
  $backup_posix_path           = $::os_service_default,
  $backup_container            = $::os_service_default,
) {

  include ::cinder::deps

  cinder_config {
    'DEFAULT/backup_driver':               value => $backup_driver;
    'DEFAULT/backup_file_size':            value => $backup_file_size;
    'DEFAULT/backup_sha_block_size_bytes': value => $backup_sha_block_size_bytes;
    'DEFAULT/backup_posix_path':           value => $backup_posix_path;
    'DEFAULT/backup_container':            value => $backup_container;
  }

}
