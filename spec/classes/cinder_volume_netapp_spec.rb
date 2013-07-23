require 'spec_helper'

describe 'cinder::volume::netapp' do

  let :params do
    {
      :netapp_login           => 'netapp',
      :netapp_password        => 'password',
      :netapp_server_hostname => '127.0.0.2',
    }
  end

  let :default_params do
    {
      :netapp_server_port            => '8088',
      :netapp_storage_service_prefix => 'openstack',
    }
  end


  shared_examples_for 'netapp volume driver' do
    let :params_hash do
      default_params.merge(params)
    end

    it 'configures netapp volume driver' do
      params_hash.each_pair do |config,value|
        should contain_cinder_config("DEFAULT/#{config}").with_value( value )
      end
    end

    it 'marks netapp_password as secret' do
      should contain_cinder_config('DEFAULT/netapp_password').with_secret( true )
    end
  end


  context 'with default parameters' do
    before do
      params = {}
    end

    it_configures 'netapp volume driver'
  end

  context 'with provided parameters' do
    it_configures 'netapp volume driver'
  end
end
