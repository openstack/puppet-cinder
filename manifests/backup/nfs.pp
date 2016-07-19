# == Class: cinder::backup::nfs
#
# Setup Cinder to backup volumes into NFS
#
# === Parameters
#
# [*backup_share*]
#   (required) The NFS share to attach to, to be specified in
#   fqdn:path, ipv4addr:path, or "[ipv6addr]:path" format.
#
# [*backup_driver*]
#   (optional) The backup driver for NFS back-end.
#   Defaults to 'cinder.backup.drivers.nfs'.
#
# [*backup_file_size*]
#   (optional) The maximum size in bytes of the files used to hold
#   backups. If the volume being backed up exceeds this size, then
#   it will be backed up into multiple files. This must be a multiple
#   of the backup_sha_block_size_bytes parameter.
#   Defaults to $::os_service_default
#
# [*backup_sha_block_size_bytes*]
#   (optional) The size in bytes that changes are tracked for
#   incremental backups.
#   Defaults to $::os_service_default
#
# [*backup_enable_progress_timer*]
#   (optional) Enable or Disable the timer to send the periodic
#   progress notifications to Ceilometer when backing up the volume
#   to the backend storage.
#   Defaults to $::os_service_default
#
# [*backup_mount_point_base*]
#   (optional) The base directory containing the mount point for the
#   NFS share.
#   Defaults to $::os_service_default
#
# [*backup_mount_options*]
#   (optional) The mount options that are passed to the NFS client.
#   Defaults to $::os_service_default
#
# [*backup_container*]
#   (optional) Custom container to use for backups.
#   Defaults to $::os_service_default
#
# [*backup_compression_algorithm*]
#   (optional) Compression algorithm to use when writing backup data.
#   Defaults to $::os_service_default
#
# === Author(s)
#
# Ryan Hefner <ryan.hefner@netapp.com>
#
# === Copyright
#
# Copyright (C) 2015 Ryan Hefner <ryan.hefner@netapp.com>
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
class cinder::backup::nfs (
  $backup_share,
  $backup_driver                = 'cinder.backup.drivers.nfs',
  $backup_file_size             = $::os_service_default,
  $backup_sha_block_size_bytes  = $::os_service_default,
  $backup_enable_progress_timer = $::os_service_default,
  $backup_mount_point_base      = $::os_service_default,
  $backup_mount_options         = $::os_service_default,
  $backup_container             = $::os_service_default,
  $backup_compression_algorithm = $::os_service_default,
) {

  include ::cinder::deps
  validate_string($backup_share)

  cinder_config {
    'DEFAULT/backup_mount_options':         value => $backup_mount_options;
    'DEFAULT/backup_share':                 value => $backup_share;
    'DEFAULT/backup_driver':                value => $backup_driver;
    'DEFAULT/backup_file_size':             value => $backup_file_size;
    'DEFAULT/backup_sha_block_size_bytes':  value => $backup_sha_block_size_bytes;
    'DEFAULT/backup_enable_progress_timer': value => $backup_enable_progress_timer;
    'DEFAULT/backup_mount_point_base':      value => $backup_mount_point_base;
    'DEFAULT/backup_container':             value => $backup_container;
    'DEFAULT/backup_compression_algorithm': value => $backup_compression_algorithm;
  }

}
