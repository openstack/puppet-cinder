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
# Unit tests for cinder::backup:glusterfs class
#

require 'spec_helper'

describe 'cinder::backup::glusterfs' do

  let :default_params do
    { :glusterfs_backup_mount_point => '<SERVICE DEFAULT>',
      :glusterfs_backup_share       => '<SERVICE DEFAULT>' }
  end

  let :params do
    {}
  end

  shared_examples_for 'cinder backup with glusterfs' do
    let :p do
      default_params.merge(params)
    end

    it 'configures cinder.conf' do
      is_expected.to contain_cinder_config('DEFAULT/backup_driver').with_value('cinder.backup.drivers.glusterfs')
      is_expected.to contain_cinder_config('DEFAULT/glusterfs_backup_mount_point').with_value(p[:glusterfs_backup_mount_point])
      is_expected.to contain_cinder_config('DEFAULT/glusterfs_backup_share').with_value(p[:glusterfs_backup_share])
    end

    context 'when overriding default parameters' do
      before :each do
        params.merge!(:glusterfs_backup_mount_point => '/usr/backup_mount')
        params.merge!(:glusterfs_backup_share => '1.2.3.4:backup_vol')
      end
      it 'should replace default parameters with new values' do
        is_expected.to contain_cinder_config('DEFAULT/glusterfs_backup_mount_point').with_value(p[:glusterfs_backup_mount_point])
        is_expected.to contain_cinder_config('DEFAULT/glusterfs_backup_share').with_value(p[:glusterfs_backup_share])
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

      it_configures 'cinder backup with glusterfs'
    end
  end

end
