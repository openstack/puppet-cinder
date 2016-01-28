#Author: Andrew Woodward <awoodward@mirantis.com>

require 'spec_helper'

describe 'cinder::type' do

  let(:title) {'hippo'}

  context 'default creation' do
    it 'should create type basic' do
      should contain_cinder_type('hippo').with(:ensure => :present)
    end
  end

  context 'creation with properties' do
    let :params do {
      :set_value      => ['name1','name2'],
      :set_key        => 'volume_backend_name',
    }
    end
    it 'should create type with properties' do
      should contain_cinder_type('hippo').with(:ensure => :present, :properties => ['volume_backend_name=name1,name2'])
    end
  end
end
