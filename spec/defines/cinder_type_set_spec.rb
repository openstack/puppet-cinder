#Author: Andrew Woodward <awoodward@mirantis.com>

require 'spec_helper'

describe 'cinder::type_set' do

  let(:title) {'hippo'}

  let :default_params do {
    :type           => 'sith',
    :key            => 'monchichi',
  }
  end

  describe 'by default' do
    let(:params){ default_params }
    it 'should create type with properties' do
      should contain_cinder_type('sith').with(:ensure => :present, :properties => ['monchichi=hippo'])
    end
  end

  describe 'with a different value' do
    let(:params){
      default_params.merge({:value => 'hippi'})
    }
    it 'should create type with properties' do
      should contain_cinder_type('sith').with(:ensure => :present, :properties => ['monchichi=hippi'])
    end
  end
end
