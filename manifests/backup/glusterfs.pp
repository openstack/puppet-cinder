# == Class: cinder::backup::glusterfs
#
# Setup Cinder to backup volumes into GlusterFS
#
# === Parameters
#
# [*backup_driver*]
#   (Optional) The backup driver for GlisterFS backend.
#   Defaults to 'cinder.backup.drivers.glusterfs'.
#
# [*glusterfs_backup_mount_point*]
#   (optional) Base dir container mount point for gluster share.
#   Defaults to $::os_service_default
#
# [*glusterfs_backup_share*]
#   (optional) GlusterFS share in <homename|ipv4addr|ipv6addr>:<gluster_vol_name> format.
#   Eg: 1.2.3.4:backup_vol
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
class cinder::backup::glusterfs (
  $backup_driver                = 'cinder.backup.drivers.glusterfs',
  $glusterfs_backup_mount_point = $::os_service_default,
  $glusterfs_backup_share       = $::os_service_default,
) {

  include ::cinder::deps

  cinder_config {
    'DEFAULT/backup_driver':                value => $backup_driver;
    'DEFAULT/glusterfs_backup_mount_point': value => $glusterfs_backup_mount_point;
    'DEFAULT/glusterfs_backup_share':       value => $glusterfs_backup_share;
  }

}
