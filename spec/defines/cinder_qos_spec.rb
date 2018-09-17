
require 'spec_helper'

describe 'cinder::qos' do

  let(:title) {'tomato'}

  context 'default creation' do
    it 'should create basic qos' do
      should contain_cinder_qos('tomato').with(:ensure => :present)
    end
  end

  context 'creation with properties' do
    let :params do {
      :properties      => ['var1=value1','var2=value2'],
      :associations    => ['vol_type1','vol_type2'],
      :consumer        => 'front-end',
    }
    end
    it 'should create qos with properties' do
      should contain_cinder_qos('tomato').with(:ensure => :present, :properties => ['var1=value1','var2=value2'], :associations => ['vol_type1','vol_type2'], :consumer => 'front-end')
    end
  end
end
