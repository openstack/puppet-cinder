require 'spec_helper'
describe 'cinder::ceilometer' do

  describe 'with default parameters' do

    let :facts do
      OSDefaults.get_facts({})
    end

    it 'contains default values' do
      is_expected.to contain_cinder_config('oslo_messaging_notifications/transport_url').with(
        :value => '<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('oslo_messaging_notifications/driver').with(
        :value => 'messagingv2')
    end
  end
end
