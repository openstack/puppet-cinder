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
# Unit tests for cinder::ceph class
#
require 'spec_helper'

describe 'cinder::backup::ceph' do
  let :params do
    {}
  end

  shared_examples 'cinder::backup::ceph' do
    it 'configures cinder.conf' do
      is_expected.to contain_cinder_config('DEFAULT/backup_driver').with_value('cinder.backup.drivers.ceph.CephBackupDriver')
      is_expected.to contain_cinder_config('DEFAULT/backup_ceph_conf').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('DEFAULT/backup_ceph_user').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('DEFAULT/backup_ceph_chunk_size').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('DEFAULT/backup_ceph_pool').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('DEFAULT/backup_ceph_stripe_unit').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('DEFAULT/backup_ceph_stripe_count').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('DEFAULT/backup_ceph_max_snapshots').with_value('<SERVICE DEFAULT>')
    end

    context 'when overriding default parameters' do
      before do
        params.merge!(
          :backup_ceph_conf          => '/tmp/ceph.conf',
          :backup_ceph_user          => 'toto',
          :backup_ceph_chunk_size    => 134217728,
          :backup_ceph_pool          => 'foo',
          :backup_ceph_stripe_unit   => 256,
          :backup_ceph_stripe_count  => 128,
          :backup_ceph_max_snapshots => 10,
        )
      end

      it 'should replace default parameters with new values' do
        is_expected.to contain_cinder_config('DEFAULT/backup_ceph_conf').with_value(params[:backup_ceph_conf])
        is_expected.to contain_cinder_config('DEFAULT/backup_ceph_user').with_value(params[:backup_ceph_user])
        is_expected.to contain_cinder_config('DEFAULT/backup_ceph_chunk_size').with_value(params[:backup_ceph_chunk_size])
        is_expected.to contain_cinder_config('DEFAULT/backup_ceph_pool').with_value(params[:backup_ceph_pool])
        is_expected.to contain_cinder_config('DEFAULT/backup_ceph_stripe_unit').with_value(params[:backup_ceph_stripe_unit])
        is_expected.to contain_cinder_config('DEFAULT/backup_ceph_stripe_count').with_value(params[:backup_ceph_stripe_count])
        is_expected.to contain_cinder_config('DEFAULT/backup_ceph_max_snapshots').with_value(params[:backup_ceph_max_snapshots])
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder::backup::ceph'
    end
  end
end
