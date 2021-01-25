require 'spec_helper'

describe 'cinder::quota' do
  shared_examples 'cinder quota' do

    context 'with defualt params' do
      let :params do
        {}
      end

      it 'contains default values' do
        is_expected.to contain_cinder_config('DEFAULT/quota_volumes').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/quota_snapshots').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/quota_gigabytes').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/quota_backups').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/quota_backup_gigabytes').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/quota_driver').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/per_volume_size_limit').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'configure quota with parameters' do
      let :params do
        {
          :quota_volumes          => 2000,
          :quota_snapshots        => 1000,
          :quota_gigabytes        => 100000,
          :quota_backups          => 100,
          :quota_backup_gigabytes => 10000,
          :quota_driver           => 'cinder.quota.DbQuotaDriver',
          :per_volume_size_limit  => 50
        }
      end

      it 'contains overrided values' do
        is_expected.to contain_cinder_config('DEFAULT/quota_volumes').with_value(2000)
        is_expected.to contain_cinder_config('DEFAULT/quota_snapshots').with_value(1000)
        is_expected.to contain_cinder_config('DEFAULT/quota_gigabytes').with_value(100000)
        is_expected.to contain_cinder_config('DEFAULT/quota_backups').with_value(100)
        is_expected.to contain_cinder_config('DEFAULT/quota_backup_gigabytes').with_value(10000)
        is_expected.to contain_cinder_config('DEFAULT/quota_driver').with_value('cinder.quota.DbQuotaDriver')
        is_expected.to contain_cinder_config('DEFAULT/per_volume_size_limit').with_value(50)
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({:os_workers => 8}))
      end

      it_behaves_like 'cinder quota'
    end
  end
end
