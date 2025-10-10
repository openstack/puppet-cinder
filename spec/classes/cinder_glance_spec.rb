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
    let :params do
      {}
    end

    context 'with defaults' do
      it 'configures cinder.conf with defaults' do
        is_expected.to contain_cinder_config('DEFAULT/glance_api_servers').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/glance_num_retries').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/glance_api_insecure').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/glance_api_ssl_compression').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/glance_request_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/allowed_direct_url_schemes').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/verify_glance_signatures').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/glance_catalog_info').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/glance_core_properties').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('glance/cafile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('glance/certfile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('glance/keyfile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('glance/insecure').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('glance/timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('glance/collect_timing').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('glance/split_loggers').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('glance/auth_type').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('glance/auth_url').with_value('http://127.0.0.1:5000')
        is_expected.to contain_cinder_config('glance/username').with_value('glance')
        is_expected.to contain_cinder_config('glance/user_domain_name').with_value('Default')
        is_expected.to contain_cinder_config('glance/password').with_value('<SERVICE DEFAULT>').with_secret(true)
        is_expected.to contain_cinder_config('glance/project_name').with_value('services')
        is_expected.to contain_cinder_config('glance/project_domain_name').with_value('Default')
        is_expected.to contain_cinder_config('glance/system_scope').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with parameters overridden' do
      before :each do
        params.merge!({
          :glance_api_servers         => '10.0.0.1:9292',
          :glance_num_retries         => 3,
          :glance_api_insecure        => false,
          :glance_api_ssl_compression => false,
          :glance_request_timeout     => 300,
          :allowed_direct_url_schemes => 'file',
          :verify_glance_signatures   => true,
          :glance_catalog_info        => 'image:glance:publicURL',
          :glance_core_properties     => 'checksum',
          :cafile                     => '/etc/ssl/certs/ca.crt',
          :certfile                   => '/etc/ssl/certs/cert.crt',
          :keyfile                    => '/etc/ssl/private/key.key',
          :insecure                   => false,
          :timeout                    => 30,
          :collect_timing             => true,
          :split_loggers              => true,
          :auth_type                  => 'password',
          :auth_url                   => 'http://127.0.0.2:5000',
          :username                   => 'alt_glance',
          :password                   => 'glancepass',
          :user_domain_name           => 'UserDomain',
          :project_name               => 'alt_service',
          :project_domain_name        => 'ProjectDomain',
        })
      end

      it 'configures cinder.conf with overridden values' do
        is_expected.to contain_cinder_config('DEFAULT/glance_api_servers').with_value('10.0.0.1:9292')
        is_expected.to contain_cinder_config('DEFAULT/glance_num_retries').with_value('3')
        is_expected.to contain_cinder_config('DEFAULT/glance_api_insecure').with_value(false)
        is_expected.to contain_cinder_config('DEFAULT/glance_api_ssl_compression').with_value(false)
        is_expected.to contain_cinder_config('DEFAULT/glance_request_timeout').with_value(300)
        is_expected.to contain_cinder_config('DEFAULT/allowed_direct_url_schemes').with_value('file')
        is_expected.to contain_cinder_config('DEFAULT/verify_glance_signatures').with_value(true)
        is_expected.to contain_cinder_config('DEFAULT/glance_catalog_info').with_value('image:glance:publicURL')
        is_expected.to contain_cinder_config('DEFAULT/glance_core_properties').with_value('checksum')
        is_expected.to contain_cinder_config('glance/cafile').with_value('/etc/ssl/certs/ca.crt')
        is_expected.to contain_cinder_config('glance/certfile').with_value('/etc/ssl/certs/cert.crt')
        is_expected.to contain_cinder_config('glance/keyfile').with_value('/etc/ssl/private/key.key')
        is_expected.to contain_cinder_config('glance/insecure').with_value(false)
        is_expected.to contain_cinder_config('glance/timeout').with_value(30)
        is_expected.to contain_cinder_config('glance/collect_timing').with_value(true)
        is_expected.to contain_cinder_config('glance/split_loggers').with_value(true)
        is_expected.to contain_cinder_config('glance/auth_type').with_value('password')
        is_expected.to contain_cinder_config('glance/auth_url').with_value('http://127.0.0.2:5000')
        is_expected.to contain_cinder_config('glance/username').with_value('alt_glance')
        is_expected.to contain_cinder_config('glance/user_domain_name').with_value('UserDomain')
        is_expected.to contain_cinder_config('glance/password').with_value('glancepass').with_secret(true)
        is_expected.to contain_cinder_config('glance/project_name').with_value('alt_service')
        is_expected.to contain_cinder_config('glance/project_domain_name').with_value('ProjectDomain')
        is_expected.to contain_cinder_config('glance/system_scope').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with parameters in array' do
      before :each do
        params.merge!({
          :glance_api_servers         => ['10.0.0.1:9292','10.0.0.2:9292'],
          :allowed_direct_url_schemes => [ 'file', 'cinder'],
          :glance_core_properties     => ['checksum', 'container_format'],
        })
      end

      it 'should configure parameters in comma-separated list' do
        is_expected.to contain_cinder_config('DEFAULT/glance_api_servers').with_value('10.0.0.1:9292,10.0.0.2:9292')
        is_expected.to contain_cinder_config('DEFAULT/allowed_direct_url_schemes').with_value('file,cinder')
        is_expected.to contain_cinder_config('DEFAULT/glance_core_properties').with_value('checksum,container_format')
      end
    end

    context 'with system_scope set' do
      before :each do
        params.merge!({
          :system_scope => 'all'
        })
      end

      it {
        is_expected.to contain_cinder_config('glance/project_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('glance/project_domain_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('glance/system_scope').with_value('all')
      }
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
