require 'spec_helper'

describe 'cinder::config' do
  let(:config_hash) do {
    'DEFAULT/foo' => { 'value'  => 'fooValue' },
    'DEFAULT/bar' => { 'value'  => 'barValue' },
    'DEFAULT/baz' => { 'ensure' => 'absent' }
  }
  end

  shared_examples 'cinder_config' do
    let :params do
      { :cinder_config => config_hash }
    end

    it { is_expected.to contain_class('cinder::deps') }

    it 'configures arbitrary cinder-config configurations' do
      is_expected.to contain_cinder_config('DEFAULT/foo').with_value('fooValue')
      is_expected.to contain_cinder_config('DEFAULT/bar').with_value('barValue')
      is_expected.to contain_cinder_config('DEFAULT/baz').with_ensure('absent')
    end
  end

  shared_examples 'cinder_api_paste_ini' do
    let :params do
      { :api_paste_ini_config => config_hash }
    end

    it 'configures arbitrary cinder-api-paste-ini configurations' do
      is_expected.to contain_cinder_api_paste_ini('DEFAULT/foo').with_value('fooValue')
      is_expected.to contain_cinder_api_paste_ini('DEFAULT/bar').with_value('barValue')
      is_expected.to contain_cinder_api_paste_ini('DEFAULT/baz').with_ensure('absent')
    end
  end

  shared_examples 'cinder_rootwrap_config' do
    let :params do
      { :cinder_rootwrap_config => config_hash }
    end

    it 'configures arbitrary cinder-rootwrap-config configurations' do
      is_expected.to contain_cinder_rootwrap_config('DEFAULT/foo').with_value('fooValue')
      is_expected.to contain_cinder_rootwrap_config('DEFAULT/bar').with_value('barValue')
      is_expected.to contain_cinder_rootwrap_config('DEFAULT/baz').with_ensure('absent')
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder_config'
      it_behaves_like 'cinder_api_paste_ini'
      it_behaves_like 'cinder_rootwrap_config'
    end
  end
end
