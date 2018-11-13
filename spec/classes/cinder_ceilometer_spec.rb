require 'spec_helper'

describe 'cinder::ceilometer' do
  shared_examples 'cinder::ceilometer' do
    context 'with default parameters' do
      it { should contain_cinder_config('oslo_messaging_notifications/transport_url').with_value('<SERVICE DEFAULT>') }
      it { should contain_cinder_config('oslo_messaging_notifications/driver').with_value('messagingv2') }
      it { should contain_cinder_config('oslo_messaging_notifications/topics').with_value('<SERVICE DEFAULT>') }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder::ceilometer'
    end
  end
end
