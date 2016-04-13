require 'spec_helper'

describe 'cinder::ceilometer' do

  describe 'with default parameters' do
    it 'contains default values' do
      is_expected.to contain_cinder_config('oslo_messaging_notifications/driver').with(
        :value => 'messagingv2')
    end
  end
end
