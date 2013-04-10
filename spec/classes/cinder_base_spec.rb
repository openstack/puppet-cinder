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
    
    it { should contain_class('cinder::params') }

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
      should contain_cinder_config('DEFAULT/rabbit_hosts').with(
        :value => '127.0.0.1:5672'
      )
      should contain_cinder_config('DEFAULT/rabbit_ha_queues').with(
        :value => 'false'
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

    it { should contain_file('/etc/cinder/cinder.conf').with(
      :owner   => 'cinder',
      :group   => 'cinder',
      :mode    => '0600',
      :require => 'Package[cinder-common]'
    ) }

    it { should contain_file('/etc/cinder/api-paste.ini').with(
      :owner   => 'cinder',
      :group   => 'cinder',
      :mode    => '0600',
      :require => 'Package[cinder-common]'
    ) }

  end
  describe 'with modified rabbit_hosts' do
    let :params do
      req_params.merge({'rabbit_hosts' => ['rabbit1:5672', 'rabbit2:5672']})
    end

    it 'should contain many' do
      should_not contain_cinder_config('DEFAULT/rabbit_host')
      should_not contain_cinder_config('DEFAULT/rabbit_port')
      should contain_cinder_config('DEFAULT/rabbit_hosts').with(
        :value => 'rabbit1:5672,rabbit2:5672'
      )
      should contain_cinder_config('DEFAULT/rabbit_ha_queues').with(
          :value => 'true'
      )
    end
  end
end
