#
# Copyright (C) 2013 eNovance SAS <licensing@enovance.com>
#
# Author: Emilien Macchi <emilien.macchi@enovance.com>
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
# == Class: cinder::backup::ceph
#
# Setup Cinder to backup volumes into Ceph
#
# === Parameters
#
# [*backup_driver*]
#   (Optional) Which cinder backup driver to use
#   Defaults to 'cinder.backup.drivers.ceph.CephBackupDriver'
#
# [*backup_ceph_conf*]
#   (Optional) Ceph config file to use.
#   Should be a valid ceph configuration file
#   Defaults to $facts['os_service_default']
#
# [*backup_ceph_user*]
#   (Optional) The Ceph user to connect with.
#   Should be a valid user
#   Defaults to $facts['os_service_default']
#
# [*backup_ceph_chunk_size*]
#   (Optional) The chunk size in bytes that a backup will be broken into
#   before transfer to backup store.
#   Should be a valid integer
#   Defaults to $facts['os_service_default']
#
# [*backup_ceph_pool*]
#   (Optional) The Ceph pool to backup to.
#   Should be a valid ceph pool
#   Defaults to $facts['os_service_default']
#
# [*backup_ceph_stripe_unit*]
#   (Optional) RBD stripe unit to use when creating a backup image.
#   Should be a valid integer
#   Defaults to $facts['os_service_default']
#
# [*backup_ceph_stripe_count*]
#   (Optional) RBD stripe count to use when creating a backup image.
#   Should be a valid integer
#   Defaults to $facts['os_service_default']
#
# [*backup_ceph_max_snapshots*]
#   (Optional) Number of the most recent snapshots to keep.
#   Defaults to $facts['os_service_default']
#
class cinder::backup::ceph (
  $backup_driver             = 'cinder.backup.drivers.ceph.CephBackupDriver',
  $backup_ceph_conf          = $facts['os_service_default'],
  $backup_ceph_user          = $facts['os_service_default'],
  $backup_ceph_chunk_size    = $facts['os_service_default'],
  $backup_ceph_pool          = $facts['os_service_default'],
  $backup_ceph_stripe_unit   = $facts['os_service_default'],
  $backup_ceph_stripe_count  = $facts['os_service_default'],
  $backup_ceph_max_snapshots = $facts['os_service_default'],
) {

  include cinder::deps

  cinder_config {
    'DEFAULT/backup_driver':             value => $backup_driver;
    'DEFAULT/backup_ceph_conf':          value => $backup_ceph_conf;
    'DEFAULT/backup_ceph_user':          value => $backup_ceph_user;
    'DEFAULT/backup_ceph_chunk_size':    value => $backup_ceph_chunk_size;
    'DEFAULT/backup_ceph_pool':          value => $backup_ceph_pool;
    'DEFAULT/backup_ceph_stripe_unit':   value => $backup_ceph_stripe_unit;
    'DEFAULT/backup_ceph_stripe_count':  value => $backup_ceph_stripe_count;
    'DEFAULT/backup_ceph_max_snapshots': value => $backup_ceph_max_snapshots;
  }

}
