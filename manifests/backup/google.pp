# == Class: cinder::backup::google
#
# Setup Cinder to backup volumes into Google Cloud Storage
#
# === Parameters
#
# [*backup_driver*]
#   (Optional) The backup driver for GCS back-end.
#   Defaults to 'cinder.backup.drivers.google'.
#
# [*backup_gcs_bucket*]
#   (optional) The GCS bucket to use.
#   Defaults to $::os_service_default
#
# [*backup_gcs_object_size*]
#   (optional) The size in bytes of GCS backup objects.
#   Defaults to $::os_service_default
#
# [*backup_gcs_block_size*]
#  (optional) The size in bytes that changes are tracked for
#  incremental backups. backup_gcs_object_size has to be a multiple
#  of backup_gcs_block_size.
#
# [*backup_gcs_reader_chunk_size*]
#   (optional) GCS object will be downloaded in chunks of bytes.
#   Defaults to $::os_service_default
#
# [*backup_gcs_writer_chunk_size*]
#   (optional) The GCS object will be uploaded in chunks of bytes.
#   Pass in a value of -1 if the file is to be uploaded as a
#   single chunk.
#   Defaults to $::os_service_default
#
# [*backup_gcs_num_retries*]
#   (optional) Number of times to retry.
#   Defaults to $::os_service_default
#
# [*backup_gcs_retry_error_codes*]
#   (optional) List of GCS error codes.
#   Defaults to $::os_service_default
#
# [*backup_gcs_bucket_location*]
#   (optional) Location of GCS bucket.
#   Defaults to $::os_service_default
#
# [*backup_gcs_storage_class*]
#   (optional) Storage class of GCS bucket.
#   Defaults to $::os_service_default
#
# [*backup_gcs_credential_file*]
#   (optional) Absolute path of GCS service account credential file.
#   Defaults to $::os_service_default
#
# [*backup_gcs_project_id*]
#   (optional) Owner project id for GCS bucket.
#  Defaults to $::os_service_default
#
# [*backup_gcs_user_agent*]
#   (optional) Http user-agent string for GCS API.
#   Defaults to $::os_service_default
#
# [*backup_gcs_enable_progress_timer*]
#   (optional) Enable or disable the timer to send the periodic
#   progress notifications to ceilometer when backing up the
#   volume to the GCS backend storage.
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
class cinder::backup::google (
  $backup_driver                    = 'cinder.backup.drivers.google',
  $backup_gcs_bucket                = $::os_service_default,
  $backup_gcs_object_size           = $::os_service_default,
  $backup_gcs_block_size            = $::os_service_default,
  $backup_gcs_reader_chunk_size     = $::os_service_default,
  $backup_gcs_writer_chunk_size     = $::os_service_default,
  $backup_gcs_num_retries           = $::os_service_default,
  $backup_gcs_retry_error_codes     = $::os_service_default,
  $backup_gcs_bucket_location       = $::os_service_default,
  $backup_gcs_storage_class         = $::os_service_default,
  $backup_gcs_credential_file       = $::os_service_default,
  $backup_gcs_project_id            = $::os_service_default,
  $backup_gcs_user_agent            = $::os_service_default,
  $backup_gcs_enable_progress_timer = $::os_service_default,
) {

  include ::cinder::deps

  cinder_config {
    'DEFAULT/backup_driver':                   value => $backup_driver;
    'DEFAULT/backup_gcs_bucket':               value => $backup_gcs_bucket;
    'DEFAULT/backup_gcs_object_size':          value => $backup_gcs_object_size;
    'DEFAULT/backup_gcs_block_size':           value => $backup_gcs_block_size;
    'DEFAULT/backup_gcs_reader_chunk_size':    value => $backup_gcs_reader_chunk_size;
    'DEFAULT/backup_gcs_writer_chunk_size':    value => $backup_gcs_writer_chunk_size;
    'DEFAULT/backup_gcs_num_retries':          value => $backup_gcs_num_retries;
    'DEFAULT/backup_gcs_retry_error_codes':    value => $backup_gcs_retry_error_codes;
    'DEFAULT/backup_gcs_bucket_location':      value => $backup_gcs_bucket_location;
    'DEFAULT/backup_gcs_storage_class':        value => $backup_gcs_storage_class;
    'DEFAULT/backup_gcs_credential_file':      value => $backup_gcs_credential_file;
    'DEFAULT/backup_gcs_project_id':           value => $backup_gcs_project_id;
    'DEFAULT/backup_gcs_user_agent':           value => $backup_gcs_user_agent;
    'DEFAULT/backup_gcs_enable_project_timer': value => $backup_gcs_enable_progress_timer;
  }

}
