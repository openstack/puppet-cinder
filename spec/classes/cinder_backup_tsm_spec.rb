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
# Unit tests for cinder::backup:tsm class
#

require 'spec_helper'

describe 'cinder::backup::tsm' do

  let :default_params do
    { :backup_tsm_volume_prefix => '<SERVICE DEFAULT>',
      :backup_tsm_password      => '<SERVICE DEFAULT>',
      :backup_tsm_compression   => '<SERVICE DEFAULT>' }
  end

  let :params do
    {}
  end

  shared_examples_for 'cinder backup with tsm' do
    let :p do
      default_params.merge(params)
    end

    it 'configures cinder.conf' do
      is_expected.to contain_cinder_config('DEFAULT/backup_driver').with_value('cinder.backup.drivers.tsm')
      is_expected.to contain_cinder_config('DEFAULT/backup_tsm_volume_prefix').with_value(p[:backup_tsm_volume_prefix])
      is_expected.to contain_cinder_config('DEFAULT/backup_tsm_password').with_value(p[:backup_tsm_password])
      is_expected.to contain_cinder_config('DEFAULT/backup_tsm_compression').with_value(p[:backup_tsm_compression])
    end

    context 'when overriding default parameters' do
      before :each do
        params.merge!(:backup_tsm_volume_prefix => 'vol-')
        params.merge!(:backup_tsm_password => 'secrete')
        params.merge!(:backup_tsm_compression => 'False')
      end
      it 'should replace default parameters with new values' do
        is_expected.to contain_cinder_config('DEFAULT/backup_tsm_volume_prefix').with_value(p[:backup_tsm_volume_prefix])
        is_expected.to contain_cinder_config('DEFAULT/backup_tsm_password').with_value(p[:backup_tsm_password])
        is_expected.to contain_cinder_config('DEFAULT/backup_tsm_compression').with_value(p[:backup_tsm_compression])
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

      it_configures 'cinder backup with tsm'
    end
  end

end
