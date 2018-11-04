#Author: Andrew Woodward <awoodward@mirantis.com>

require 'spec_helper'

describe 'cinder::type_set' do
  let(:title) {'hippo'}

  let :default_params do
    {
      :type => 'sith',
      :key  => 'monchichi',
    }
  end

  let :params do
    default_params
  end

  shared_examples 'cinder::type_set' do
    context 'by default' do
      it { should contain_cinder_type('sith').with(
        :ensure     => 'present',
        :properties => ['monchichi=hippo']
      )}
    end

    context 'with a different value' do
      before do
        params.merge!( :value => 'hippi' )
      end

      it { should contain_cinder_type('sith').with(
        :ensure     => 'present',
        :properties => ['monchichi=hippi']
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

      it_behaves_like 'cinder::type_set'
    end
  end
end
