require 'spec_helper'

describe 'cinder::volume::netapp' do

  let :req_params do {
    :netapp_wsdl_url        => 'http://127.0.0.1/dfm.wsdl',
    :netapp_login           => 'netapp',
    :netapp_password        => 'password',
    :netapp_server_hostname => '127.0.0.2',
    :netapp_storage_service => 'OpenStack',
  } end

  let :default_params do {
    :netapp_server_port            => '8088',
    :netapp_storage_service_prefix => 'openstack',
  } end

  describe 'with default params' do

    let :params_hash do
      default_params.merge(req_params)
    end

   it 'should lay down netapp config' do
     params_hash.keys do |config|
       should contain_cinder_config("DEFAULT/#{config}").with_value(param_hash[config])
     end
   end
  end
end
