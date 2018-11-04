#
# Copyright (C) 2014 eNovance SAS <licensing@enovance.com>
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
# Unit tests for cinder::backends class
#
require 'spec_helper'

describe 'cinder::backends' do
  let :default_params do
    {}
  end

  let :params do
    {}
  end

  shared_examples 'cinder backends' do

    let :p do
      default_params.merge(params)
    end

    context 'configure cinder with default parameters' do
      before :each do
        params.merge!(
         :enabled_backends => ['lowcost', 'regular', 'premium'],
        )
      end

      it 'configures cinder.conf with default params' do
        is_expected.to contain_cinder_config('DEFAULT/enabled_backends').with_value(p[:enabled_backends].join(','))
        is_expected.to_not contain_cinder_config('lowcost/backend_host')
        is_expected.to_not contain_cinder_config('regular/backend_host')
        is_expected.to_not contain_cinder_config('premium/backend_host')
      end
    end

    context 'configure cinder with backend_host' do
      before :each do
        params.merge!(
          :enabled_backends => ['lowcost', 'regular', 'premium'],
          :backend_host     => 'somehost',
        )
      end

      let(:pre_condition) do
        # Verify there are no collisions with any previously defined value.
        "cinder_config { 'regular/backend_host': value => 'anotherhost' }"
      end

      it 'configures backend_host in each backend' do
        is_expected.to contain_cinder_config('lowcost/backend_host').with_value('somehost')
        is_expected.to contain_cinder_config('regular/backend_host').with_value('anotherhost')
        is_expected.to contain_cinder_config('premium/backend_host').with_value('somehost')
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts)
      end

      it_behaves_like 'cinder backends'
    end
  end
end
