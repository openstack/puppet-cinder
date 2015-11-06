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

require 'spec_helper'

describe 'cinder::backup::nfs' do

  let :params do
    {
      :backup_share => '10.0.0.1:/nfs_backup',
    }
  end

  let :default_params do
    {
      :backup_driver                => 'cinder.backup.drivers.nfs',
      :backup_file_size             => '<SERVICE DEFAULT>',
      :backup_sha_block_size_bytes  => '<SERVICE DEFAULT>',
      :backup_enable_progress_timer => '<SERVICE DEFAULT>',
      :backup_mount_point_base      => '<SERVICE DEFAULT>',
      :backup_mount_options         => '<SERVICE DEFAULT>',
      :backup_container             => '<SERVICE DEFAULT>',
      :backup_compression_algorithm => '<SERVICE DEFAULT>',
    }
  end

  shared_examples_for 'cinder backup with nfs' do
    let :all_params do
      default_params.merge(params)
    end

    it 'configures cinder.conf' do
      all_params.each_pair do |config,value|
        is_expected.to contain_cinder_config("DEFAULT/#{config}").with_value( value )
      end
    end

    context 'with optional parameters' do
      let (:all_params) { params.merge!({
        :backup_mount_options => 'sec=sys',
        :backup_container     => 'container',
      }) }

      it 'should include optional values' do
        is_expected.to contain_cinder_config('DEFAULT/backup_mount_options').with_value(all_params[:backup_mount_options])
        is_expected.to contain_cinder_config('DEFAULT/backup_container').with_value(all_params[:backup_container])
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

      it_configures 'cinder backup with nfs'
    end
  end
end
