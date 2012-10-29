require 'spec_helper'
describe 'cinder::base' do
  let :req_params do
    {:rabbit_password => 'rpw', :sql_connection => 'mysql://user:password@host/database'}
  end

  let :facts do
    {:osfamily => 'Debian'}
  end

  describe 'with only required params' do
    let :params do
      req_params
    end

    it 'should contain default config' do
      should contain_cinder_config('DEFAULT/rabbit_password').with(
        :value => 'rpw'
      )
      should contain_cinder_config('DEFAULT/rabbit_host').with(
        :value => '127.0.0.1'
      )
      should contain_cinder_config('DEFAULT/rabbit_port').with(
        :value => '5672'
      )
      should contain_cinder_config('DEFAULT/rabbit_virtual_host').with(
        :value => '/'
      )
      should contain_cinder_config('DEFAULT/rabbit_userid').with(
        :value => 'nova'
      )
      should contain_cinder_config('DEFAULT/sql_connection').with(
        :value => 'mysql://user:password@host/database'
      )
      should contain_cinder_config('DEFAULT/verbose').with(
        :value => 'False'
      )
      should contain_cinder_config('DEFAULT/api_paste_config').with(
        :value => '/etc/cinder/api-paste.ini'
      )
    end

  end
end
