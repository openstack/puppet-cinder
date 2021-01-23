require 'spec_helper'

describe 'cinder::key_manager' do
  shared_examples 'cinder::key_manager' do
    context 'with default parameters' do
      it {
        is_expected.to contain_oslo__key_manager('cinder_config').with(
          :backend => '<SERVICE DEFAULT>'
        )
      }
    end

    context 'with specified parameters' do
      let :params do
        {
          :backend => 'barbican'
        }
      end

      it {
        is_expected.to contain_oslo__key_manager('cinder_config').with(
          :backend => 'barbican'
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

      it_behaves_like 'cinder::key_manager'
    end
  end
end
