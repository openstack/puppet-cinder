#Author: Andrew Woodward <awoodward@mirantis.com>

require 'spec_helper'

describe 'cinder::type' do
  let(:title) {'hippo'}

  shared_examples 'cinder::type' do
    context 'default creation' do
      it { should contain_cinder_type('hippo').with_ensure('present') }
    end

    context 'creation with properties' do
      let :params do
        {
          :set_value => ['name1', 'name2'],
          :set_key   => 'volume_backend_name',
        }
      end

      it { should contain_cinder_type('hippo').with(
        :ensure     => 'present',
        :properties => ['volume_backend_name=name1,name2']
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder::type'
    end
  end
end
