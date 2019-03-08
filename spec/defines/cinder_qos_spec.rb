
require 'spec_helper'

describe 'cinder::qos' do
  let(:title) {'tomato'}

  shared_examples 'cinder::qos' do
    context 'with default parameters' do
      it { is_expected.to contain_cinder_qos('tomato').with_ensure('present') }
    end

    context 'with specified parameters' do
      let :params do
        {
          :properties   => ['var1=value1', 'var2=value2'],
          :associations => ['vol_type1', 'vol_type2'],
          :consumer     => 'front-end',
        }
      end

      it { is_expected.to contain_cinder_qos('tomato').with(
        :ensure       => 'present',
        :properties   => ['var1=value1', 'var2=value2'],
        :associations => ['vol_type1', 'vol_type2'],
        :consumer     => 'front-end'
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

      it_behaves_like 'cinder::qos'
    end
  end
end
