#
# Copyright (C) 2016 Intel
#
# Author: Nate Potter <nathaniel.potter@intel.com>
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
# Unit tests for cinder::backup::google class
#

require 'spec_helper'

describe 'cinder::backup::google' do

  let :default_params do
    { :backup_gcs_bucket                => '<SERVICE DEFAULT>',
      :backup_gcs_object_size           => '<SERVICE DEFAULT>',
      :backup_gcs_block_size            => '<SERVICE DEFAULT>',
      :backup_gcs_reader_chunk_size     => '<SERVICE DEFAULT>',
      :backup_gcs_writer_chunk_size     => '<SERVICE DEFAULT>',
      :backup_gcs_num_retries           => '<SERVICE DEFAULT>',
      :backup_gcs_retry_error_codes     => '<SERVICE DEFAULT>',
      :backup_gcs_bucket_location       => '<SERVICE DEFAULT>',
      :backup_gcs_storage_class         => '<SERVICE DEFAULT>',
      :backup_gcs_credential_file       => '<SERVICE DEFAULT>',
      :backup_gcs_project_id            => '<SERVICE DEFAULT>',
      :backup_gcs_user_agent            => '<SERVICE DEFAULT>',
      :backup_gcs_enable_progress_timer => '<SERVICE DEFAULT>' }
  end

  let :params do
    {}
  end

  shared_examples_for 'cinder backup with google cloud storage' do
    let :p do
      default_params.merge(params)
    end

    it 'configures cinder.conf' do
      is_expected.to contain_cinder_config('DEFAULT/backup_driver').with_value('cinder.backup.drivers.google')
      is_expected.to contain_cinder_config('DEFAULT/backup_gcs_bucket').with_value(p[:backup_gcs_bucket])
      is_expected.to contain_cinder_config('DEFAULT/backup_gcs_object_size').with_value(p[:backup_gcs_object_size])
      is_expected.to contain_cinder_config('DEFAULT/backup_gcs_block_size').with_value(p[:backup_gcs_block_size])
      is_expected.to contain_cinder_config('DEFAULT/backup_gcs_reader_chunk_size').with_value(p[:backup_gcs_reader_chunk_size])
      is_expected.to contain_cinder_config('DEFAULT/backup_gcs_writer_chunk_size').with_value(p[:backup_gcs_writer_chunk_size])
      is_expected.to contain_cinder_config('DEFAULT/backup_gcs_num_retries').with_value(p[:backup_gcs_num_retries])
      is_expected.to contain_cinder_config('DEFAULT/backup_gcs_retry_error_codes').with_value(p[:backup_gcs_retry_error_codes])
      is_expected.to contain_cinder_config('DEFAULT/backup_gcs_bucket_location').with_value(p[:backup_gcs_bucket_location])
      is_expected.to contain_cinder_config('DEFAULT/backup_gcs_storage_class').with_value(p[:backup_gcs_storage_class])
      is_expected.to contain_cinder_config('DEFAULT/backup_gcs_credential_file').with_value(p[:backup_gcs_credential_file])
      is_expected.to contain_cinder_config('DEFAULT/backup_gcs_project_id').with_value(p[:backup_gcs_project_id])
      is_expected.to contain_cinder_config('DEFAULT/backup_gcs_user_agent').with_value(p[:backup_gcs_user_agent])
      is_expected.to contain_cinder_config('DEFAULT/backup_gcs_enable_project_timer').with_value(p[:backup_gcs_enable_progress_timer])
    end

    context 'when overriding default parameters' do
      before :each do
        params.merge!(:backup_gcs_bucket => 'bigbucket')
        params.merge!(:backup_gcs_object_size => '1992')
        params.merge!(:backup_gcs_block_size => '12')
        params.merge!(:backup_gcs_reader_chunk_size => '27')
        params.merge!(:backup_gcs_writer_chunk_size => '-1')
        params.merge!(:backup_gcs_num_retries => '42')
        params.merge!(:backup_gcs_retry_error_codes => '430')
        params.merge!(:backup_gcs_bucket_location => 'NO')
        params.merge!(:backup_gcs_storage_class => 'FARLINE')
        params.merge!(:backup_gcs_credential_file => '/etc/file')
        params.merge!(:backup_gcs_project_id => 'me')
        params.merge!(:backup_gcs_user_agent => '007')
        params.merge!(:backup_gcs_enable_progress_timer => 'false')
      end
      it 'should replace default parameters with new values' do
        is_expected.to contain_cinder_config('DEFAULT/backup_gcs_bucket').with_value(p[:backup_gcs_bucket])
        is_expected.to contain_cinder_config('DEFAULT/backup_gcs_object_size').with_value(p[:backup_gcs_object_size])
        is_expected.to contain_cinder_config('DEFAULT/backup_gcs_block_size').with_value(p[:backup_gcs_block_size])
        is_expected.to contain_cinder_config('DEFAULT/backup_gcs_reader_chunk_size').with_value(p[:backup_gcs_reader_chunk_size])
        is_expected.to contain_cinder_config('DEFAULT/backup_gcs_writer_chunk_size').with_value(p[:backup_gcs_writer_chunk_size])
        is_expected.to contain_cinder_config('DEFAULT/backup_gcs_num_retries').with_value(p[:backup_gcs_num_retries])
        is_expected.to contain_cinder_config('DEFAULT/backup_gcs_retry_error_codes').with_value(p[:backup_gcs_retry_error_codes])
        is_expected.to contain_cinder_config('DEFAULT/backup_gcs_bucket_location').with_value(p[:backup_gcs_bucket_location])
        is_expected.to contain_cinder_config('DEFAULT/backup_gcs_storage_class').with_value(p[:backup_gcs_storage_class])
        is_expected.to contain_cinder_config('DEFAULT/backup_gcs_credential_file').with_value(p[:backup_gcs_credential_file])
        is_expected.to contain_cinder_config('DEFAULT/backup_gcs_project_id').with_value(p[:backup_gcs_project_id])
        is_expected.to contain_cinder_config('DEFAULT/backup_gcs_user_agent').with_value(p[:backup_gcs_user_agent])
        is_expected.to contain_cinder_config('DEFAULT/backup_gcs_enable_project_timer').with_value(p[:backup_gcs_enable_progress_timer])
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({:processorcount => 8}))
      end

      it_configures 'cinder backup with google cloud storage'
    end
  end

end
