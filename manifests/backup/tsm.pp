# == Class: cinder::backup::tsm
#
# Setup Cinder to backup volumes into the Tivoli Storage Manager (TSM)
#
# === Parameters
#
# [*backup_driver*]
#   (Optional) The backup driver for tsm backend.
#   Defaults to 'cinder.backup.drivers.tsm'.
#
# [*backup_tsm_volume_prefix*]
#   (optional) Volume prefix for the backup id when backing up to TSM.
#   Defaults to $::os_service_default
#
# [*backup_tsm_password*]
#   (optional) TSM password for the running username.
#   Defaults to $::os_service_default
#
# [*backup_tsm_compression*]
#   (optional) Enable or Disable compression for backups.
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
class cinder::backup::tsm (
  $backup_driver            = 'cinder.backup.drivers.tsm',
  $backup_tsm_volume_prefix = $::os_service_default,
  $backup_tsm_password      = $::os_service_default,
  $backup_tsm_compression   = $::os_service_default,
) {

  include ::cinder::deps

  cinder_config {
    'DEFAULT/backup_driver':            value => $backup_driver;
    'DEFAULT/backup_tsm_volume_prefix': value => $backup_tsm_volume_prefix;
    'DEFAULT/backup_tsm_password':      value => $backup_tsm_password, secret => true;
    'DEFAULT/backup_tsm_compression':   value => $backup_tsm_compression;
  }

}
