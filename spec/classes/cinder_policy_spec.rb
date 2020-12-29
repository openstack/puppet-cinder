require 'spec_helper'

describe 'cinder::policy' do
  shared_examples 'cinder policies' do
    let :params do
      {
        :policy_path => '/etc/cinder/policy.yaml',
        :policies    => {
          'context_is_admin' => {
            'key'   => 'context_is_admin',
            'value' => 'foo:bar'
          }
        }
      }
    end

    it 'set up the policies' do
      is_expected.to contain_openstacklib__policy__base('context_is_admin').with({
        :key         => 'context_is_admin',
        :value       => 'foo:bar',
        :file_user   => 'root',
        :file_group  => 'cinder',
        :file_format => 'yaml',
      })
      is_expected.to contain_oslo__policy('cinder_config').with(
        :policy_file => '/etc/cinder/policy.yaml',
      )
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder policies'
    end
  end
end
