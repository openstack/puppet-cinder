require 'spec_helper'

describe 'cinder::coordination' do
  shared_examples 'cinder::coordination' do
    context 'with default parameters' do
      it {
        is_expected.to contain_oslo__coordination('cinder_config').with(
          :backend_url            => '<SERVICE DEFAULT>',
          :manage_backend_package => true,
          :package_ensure         => 'present',
        )
      }
    end

    context 'with specified parameters' do
      let :params do
        {
          :backend_url            => 'etcd3+http://127.0.0.1:2379',
          :manage_backend_package => false,
          :package_ensure         => 'latest',
        }
      end

      it {
        is_expected.to contain_oslo__coordination('cinder_config').with(
          :backend_url            => 'etcd3+http://127.0.0.1:2379',
          :manage_backend_package => false,
          :package_ensure         => 'latest',
        )
      }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder::coordination'
    end
  end
end
