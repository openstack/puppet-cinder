require 'spec_helper'

describe 'cinder::policy' do
  shared_examples 'cinder::policy' do

    context 'setup policy with parameters' do
      let :params do
        {
          :enforce_scope        => false,
          :enforce_new_defaults => false,
          :policy_path          => '/etc/cinder/policy.yaml',
          :policy_dirs          => '/etc/cinder/policy.d',
          :policies             => {
            'context_is_admin' => {
              'key'   => 'context_is_admin',
              'value' => 'foo:bar'
            }
          }
        }
      end

      it 'set up the policies' do
        is_expected.to contain_openstacklib__policy('/etc/cinder/policy.yaml').with(
          :policies     => {
            'context_is_admin' => {
              'key'   => 'context_is_admin',
              'value' => 'foo:bar'
            }
          },
          :policy_path  => '/etc/cinder/policy.yaml',
          :file_user    => 'root',
          :file_group   => 'cinder',
          :file_format  => 'yaml',
          :purge_config => false,
        )
        is_expected.to contain_oslo__policy('cinder_config').with(
          :enforce_scope        => false,
          :enforce_new_defaults => false,
          :policy_file          => '/etc/cinder/policy.yaml',
          :policy_dirs          => '/etc/cinder/policy.d',
        )
      end
    end

    context 'with empty policies and purge_config enabled' do
      let :params do
        {
          :enforce_scope        => false,
          :enforce_new_defaults => false,
          :policy_path          => '/etc/cinder/policy.yaml',
          :policies             => {},
          :purge_config         => true,
        }
      end

      it 'set up the policies' do
        is_expected.to contain_openstacklib__policy('/etc/cinder/policy.yaml').with(
          :policies     => {},
          :policy_path  => '/etc/cinder/policy.yaml',
          :file_user    => 'root',
          :file_group   => 'cinder',
          :file_format  => 'yaml',
          :purge_config => true,
        )
        is_expected.to contain_oslo__policy('cinder_config').with(
          :enforce_scope        => false,
          :enforce_new_defaults => false,
          :policy_file          => '/etc/cinder/policy.yaml',
        )
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder::policy'
    end
  end
end
