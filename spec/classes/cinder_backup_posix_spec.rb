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
# Unit tests for cinder::backup:posix class
#

require 'spec_helper'

describe 'cinder::backup::posix' do

  let :default_params do
    { :backup_file_size             => '<SERVICE DEFAULT>',
      :backup_sha_block_size_bytes  => '<SERVICE DEFAULT>',
      :backup_enable_progress_timer => '<SERVICE DEFAULT>',
      :backup_posix_path            => '<SERVICE DEFAULT>',
      :backup_container             => '<SERVICE DEFAULT>' }
  end

  let :params do
    {}
  end

  shared_examples_for 'cinder backup with posix' do
    let :p do
      default_params.merge(params)
    end

    it 'configures cinder.conf' do
      is_expected.to contain_cinder_config('DEFAULT/backup_driver').with_value('cinder.backup.drivers.posix')
      is_expected.to contain_cinder_config('DEFAULT/backup_file_size').with_value(p[:backup_file_size])
      is_expected.to contain_cinder_config('DEFAULT/backup_sha_block_size_bytes').with_value(p[:backup_sha_block_size_bytes])
      is_expected.to contain_cinder_config('DEFAULT/backup_posix_path').with_value(p[:backup_posix_path])
      is_expected.to contain_cinder_config('DEFAULT/backup_container').with_value(p[:backup_container])
    end

    context 'when overriding default parameters' do
      before :each do
        params.merge!(:backup_file_size => '4')
        params.merge!(:backup_sha_block_size_bytes => '2')
        params.merge!(:backup_posix_path => '/etc/backup')
        params.merge!(:backup_container => 'mycontainer')
      end
      it 'should replace default parameters with new values' do
        is_expected.to contain_cinder_config('DEFAULT/backup_file_size').with_value(p[:backup_file_size])
        is_expected.to contain_cinder_config('DEFAULT/backup_sha_block_size_bytes').with_value(p[:backup_sha_block_size_bytes])
        is_expected.to contain_cinder_config('DEFAULT/backup_posix_path').with_value(p[:backup_posix_path])
        is_expected.to contain_cinder_config('DEFAULT/backup_container').with_value(p[:backup_container])
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

      it_configures 'cinder backup with posix'
    end
  end

end
