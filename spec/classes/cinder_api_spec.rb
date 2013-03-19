require 'spec_helper'

describe 'cinder::api' do

  let :req_params do
    {:keystone_password => 'foo'}
  end
  let :facts do
    {:osfamily => 'Debian'}
  end

  describe 'with only required params' do
    let :params do
      req_params
    end
    it 'should configure cinder api correctly' do
      should contain_cinder_config('DEFAULT/auth_strategy').with(
       :value => 'keystone'
      )
      should contain_cinder_config('DEFAULT/bind_host').with(
       :value => '0.0.0.0'
      )
      should contain_cinder_api_paste_ini('filter:authtoken/service_protocol').with(
        :value => 'http'
      )
      should contain_cinder_api_paste_ini('filter:authtoken/service_host').with(
        :value => 'localhost'
      )
      should contain_cinder_api_paste_ini('filter:authtoken/service_port').with(
        :value => '5000'
      )
      should contain_cinder_api_paste_ini('filter:authtoken/auth_protocol').with(
        :value => 'http'
      )
      should contain_cinder_api_paste_ini('filter:authtoken/auth_host').with(
        :value => 'localhost'
      )
      should contain_cinder_api_paste_ini('filter:authtoken/auth_port').with(
        :value => '35357'
      )
      should contain_cinder_api_paste_ini('filter:authtoken/admin_tenant_name').with(
        :value => 'services'
      )
      should contain_cinder_api_paste_ini('filter:authtoken/admin_user').with(
        :value => 'cinder'
      )
      should contain_cinder_api_paste_ini('filter:authtoken/admin_password').with(
        :value => 'foo'
      )
    end
  end

  describe 'with only required params' do
    let :params do
      req_params.merge({'bind_host' => '192.168.1.3'})
    end
    it 'should configure cinder api correctly' do
      should contain_cinder_config('DEFAULT/bind_host').with(
       :value => '192.168.1.3'
      )
    end
  end
end
