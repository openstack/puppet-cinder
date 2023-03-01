#
# Copyright (C) 2021 Red Hat, Inc.
#
# Alan Bishop <abishop@redhat.com>
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
# Unit tests for cinder::backup::s3 class
#
require 'spec_helper'

describe 'cinder::backup::s3' do
  let :params do
    {
      :backup_s3_endpoint_url     => 'http://my.s3.server',
      :backup_s3_store_access_key => '12345',
      :backup_s3_store_secret_key => '67890',
    }
  end

  let :default_params do
    {
      :backup_driver                    => 'cinder.backup.drivers.s3.S3BackupDriver',
      :backup_compression_algorithm     => '<SERVICE DEFAULT>',
      :backup_s3_store_bucket           => '<SERVICE DEFAULT>',
      :backup_s3_object_size            => '<SERVICE DEFAULT>',
      :backup_s3_block_size             => '<SERVICE DEFAULT>',
      :backup_s3_enable_progress_timer  => '<SERVICE DEFAULT>',
      :backup_s3_http_proxy             => '<SERVICE DEFAULT>',
      :backup_s3_https_proxy            => '<SERVICE DEFAULT>',
      :backup_s3_timeout                => '<SERVICE DEFAULT>',
      :backup_s3_max_pool_connections   => '<SERVICE DEFAULT>',
      :backup_s3_retry_max_attempts     => '<SERVICE DEFAULT>',
      :backup_s3_retry_mode             => '<SERVICE DEFAULT>',
      :backup_s3_verify_ssl             => '<SERVICE DEFAULT>',
      :backup_s3_ca_cert_file           => '<SERVICE DEFAULT>',
      :backup_s3_md5_validation         => '<SERVICE DEFAULT>',
      :backup_s3_sse_customer_key       => '<SERVICE DEFAULT>',
      :backup_s3_sse_customer_algorithm => '<SERVICE DEFAULT>',
    }
  end

  let :custom_params do
    {
      :backup_compression_algorithm     => 'bz2',
      :backup_s3_store_bucket           => 'my_backups',
      :backup_s3_object_size            => '26214400',
      :backup_s3_block_size             => '16536',
      :backup_s3_enable_progress_timer  => false,
      :backup_s3_http_proxy             => 'http://my.s3.http-proxy',
      :backup_s3_https_proxy            => 'https://my.s3.https-proxy',
      :backup_s3_timeout                => 66,
      :backup_s3_max_pool_connections   => 15,
      :backup_s3_retry_max_attempts     => 13,
      :backup_s3_retry_mode             => 'adaptive',
      :backup_s3_verify_ssl             => false,
      :backup_s3_ca_cert_file           => '/path/to/cert',
      :backup_s3_md5_validation         => false,
      :backup_s3_sse_customer_key       => 'my_key',
      :backup_s3_sse_customer_algorithm => 'my_algorithm',
    }
  end

  shared_examples 'cinder S3 backup driver' do
    let :params_hash do
      default_params.merge(params)
    end

    it 'configures the S3 backup driver' do
      params_hash.each_pair do |config,value|
        is_expected.to contain_cinder_config("DEFAULT/#{config}").with_value(value)
      end
    end

    it 'properly handles secrets' do
      is_expected.to contain_cinder_config('DEFAULT/backup_s3_store_access_key').with_secret(true)
      is_expected.to contain_cinder_config('DEFAULT/backup_s3_store_secret_key').with_secret(true)
      is_expected.to contain_cinder_config('DEFAULT/backup_s3_sse_customer_key').with_secret(true)
    end
  end

  shared_examples 'cinder::backup::s3' do
    context 'with default parameters' do
      it_behaves_like 'cinder S3 backup driver'
    end

    context 'with custom parameters' do
      before do
        params.merge(custom_params)
      end

      it_behaves_like 'cinder S3 backup driver'
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder::backup::s3'
    end
  end
end
