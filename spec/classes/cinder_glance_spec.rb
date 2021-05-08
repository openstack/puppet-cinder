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
# Unit tests for cinder::glance class
#
require 'spec_helper'

describe 'cinder::glance' do
  shared_examples 'cinder::glance' do
    context 'with defaults' do
      let :params do
        {}
      end

      it 'configures cinder.conf with defaults' do
        is_expected.to contain_cinder_config('DEFAULT/glance_api_servers').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/glance_num_retries').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/glance_api_insecure').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/glance_api_ssl_compression').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/glance_request_timeout').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with parameters overridden' do
      let :params do
        {
          :glance_api_servers         => '10.0.0.1:9292',
          :glance_num_retries         => 3,
          :glance_api_insecure        => false,
          :glance_api_ssl_compression => false,
          :glance_request_timeout     => 300,
        }
      end

      it 'configures cinder.conf with defaults' do
        is_expected.to contain_cinder_config('DEFAULT/glance_api_servers').with_value('10.0.0.1:9292')
        is_expected.to contain_cinder_config('DEFAULT/glance_num_retries').with_value('3')
        is_expected.to contain_cinder_config('DEFAULT/glance_api_insecure').with_value(false)
        is_expected.to contain_cinder_config('DEFAULT/glance_api_ssl_compression').with_value(false)
        is_expected.to contain_cinder_config('DEFAULT/glance_request_timeout').with_value(300)
      end
    end

    context 'with parameters in array' do
      let :params do
        {
          :glance_api_servers => ['10.0.0.1:9292','10.0.0.2:9292'],
        }
      end

      it 'should configure parameters in comma-separated list' do
        is_expected.to contain_cinder_config('DEFAULT/glance_api_servers').with_value('10.0.0.1:9292,10.0.0.2:9292')
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    let (:facts) do
      facts.merge(OSDefaults.get_facts())
    end

    context "on #{os}" do
      it_behaves_like 'cinder::glance'
    end
  end
end
