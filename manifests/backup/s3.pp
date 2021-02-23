# == Class: cinder::backup::s3
#
# Setup Cinder to backup volumes into an S3 server,
#
# === Parameters
#
# [*backup_s3_endpoint_url*]
#   (required) The url where the S3 server is listening.
#
# [*backup_s3_store_access_key*]
#   (required) The S3 query token access key.
#
# [*backup_s3_store_secret_key*]
#   (required) The S3 query token secret key.
#
# [*backup_driver*]
#   (Optional) The backup driver for S3 backend.
#   Defaults to 'cinder.backup.drivers.s3.S3BackupDriver'.
#
# [*backup_compression_algorithm*]
#   (optional) Compression algorithm to use for volume backups.
#   Supported options are: None (to disable), zlib, bz2 and zstd.
#   Defaults to $::os_service_default
#
# [*backup_s3_store_bucket*]
#   (optional) The S3 bucket to be used to store the Cinder backup data.
#   Defaults to $::os_service_default
#
# [*backup_s3_object_size*]
#   (optional) The size in bytes of S3 backup objects.
#   Defaults to $::os_service_default
#
# [*backup_s3_block_size*]
#   (optional) The size in bytes that changes are tracked for incremental
#   backups. backup_s3_object_size has to be multiple of backup_s3_block_size.
#   Defaults to $::os_service_default
#
# [*backup_s3_enable_progress_timer*]
#   (optional) Enable or Disable the timer to send the periodic progress
#   notifications to Ceilometer when backing up the volume to the S3
#   backend storage.
#   Defaults to $::os_service_default
#
# [*backup_s3_http_proxy*]
#   (optional) Address or host for the http proxy server.
#   Defaults to $::os_service_default
#
# [*backup_s3_https_proxy*]
#   (optional) Address or host for the https proxy server.
#   Defaults to $::os_service_default
#
# [*backup_s3_timeout*]
#   (optional) The time in seconds till a timeout exception is thrown.
#   Defaults to $::os_service_default
#
# [*backup_s3_max_pool_connections*]
#   (optional) The maximum number of connections to keep in a connection pool.
#   Defaults to $::os_service_default
#
# [*backup_s3_retry_max_attempts*]
#   (optional) An integer representing the maximum number of
#   retry attempts that will be made on a single request.
#   Defaults to $::os_service_default
#
# [*backup_s3_retry_mode*]
#   (optional) A string representing the type of retry mode.
#    e.g: legacy, standard, adaptive.
#   Defaults to $::os_service_default
#
# [*backup_s3_verify_ssl*]
#   (optional) Enable or Disable ssl verify.
#   Defaults to $::os_service_default
#
# [*backup_s3_ca_cert_file*]
#   (optional) A filename of the CA cert bundle to use.
#   Defaults to $::os_service_default
#
# [*backup_s3_md5_validation*]
#   (optional) Enable or Disable md5 validation in the s3 backend.
#   Defaults to $::os_service_default
#
# [*backup_s3_sse_customer_key*]
#   (optional) The SSECustomerKey.
#   Defaults to $::os_service_default
#
# [*backup_s3_sse_customer_algorithm*]
#   (optional) The SSECustomerAlgorithm.
#   Defaults to $::os_service_default
#
# === Author(s)
#
# Alan Bishop <abishop@redhat.com>
#
# === Copyright
#
# Copyright (C) 2021 Red Hat, Inc.
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
class cinder::backup::s3 (
  $backup_s3_endpoint_url,
  $backup_s3_store_access_key,
  $backup_s3_store_secret_key,
  $backup_driver                    = 'cinder.backup.drivers.s3.S3BackupDriver',
  $backup_compression_algorithm     = $::os_service_default,
  $backup_s3_store_bucket           = $::os_service_default,
  $backup_s3_object_size            = $::os_service_default,
  $backup_s3_block_size             = $::os_service_default,
  $backup_s3_enable_progress_timer  = $::os_service_default,
  $backup_s3_http_proxy             = $::os_service_default,
  $backup_s3_https_proxy            = $::os_service_default,
  $backup_s3_timeout                = $::os_service_default,
  $backup_s3_max_pool_connections   = $::os_service_default,
  $backup_s3_retry_max_attempts     = $::os_service_default,
  $backup_s3_retry_mode             = $::os_service_default,
  $backup_s3_verify_ssl             = $::os_service_default,
  $backup_s3_ca_cert_file           = $::os_service_default,
  $backup_s3_md5_validation         = $::os_service_default,
  $backup_s3_sse_customer_key       = $::os_service_default,
  $backup_s3_sse_customer_algorithm = $::os_service_default,
) {

  include cinder::deps

  cinder_config {
    'DEFAULT/backup_s3_endpoint_url':           value => $backup_s3_endpoint_url;
    'DEFAULT/backup_s3_store_access_key':       value => $backup_s3_store_access_key, secret => true;
    'DEFAULT/backup_s3_store_secret_key':       value => $backup_s3_store_secret_key, secret => true;
    'DEFAULT/backup_driver':                    value => $backup_driver;
    'DEFAULT/backup_compression_algorithm':     value => $backup_compression_algorithm;
    'DEFAULT/backup_s3_store_bucket':           value => $backup_s3_store_bucket;
    'DEFAULT/backup_s3_object_size':            value => $backup_s3_object_size;
    'DEFAULT/backup_s3_block_size':             value => $backup_s3_block_size;
    'DEFAULT/backup_s3_enable_progress_timer':  value => $backup_s3_enable_progress_timer;
    'DEFAULT/backup_s3_http_proxy':             value => $backup_s3_http_proxy;
    'DEFAULT/backup_s3_https_proxy':            value => $backup_s3_https_proxy;
    'DEFAULT/backup_s3_timeout':                value => $backup_s3_timeout;
    'DEFAULT/backup_s3_max_pool_connections':   value => $backup_s3_max_pool_connections;
    'DEFAULT/backup_s3_retry_max_attempts':     value => $backup_s3_retry_max_attempts;
    'DEFAULT/backup_s3_retry_mode':             value => $backup_s3_retry_mode;
    'DEFAULT/backup_s3_verify_ssl':             value => $backup_s3_verify_ssl;
    'DEFAULT/backup_s3_ca_cert_file':           value => $backup_s3_ca_cert_file;
    'DEFAULT/backup_s3_md5_validation':         value => $backup_s3_md5_validation;
    'DEFAULT/backup_s3_sse_customer_key':       value => $backup_s3_sse_customer_key, secret => true;
    'DEFAULT/backup_s3_sse_customer_algorithm': value => $backup_s3_sse_customer_algorithm;
  }

}
