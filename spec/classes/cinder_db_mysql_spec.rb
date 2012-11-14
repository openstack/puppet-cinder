require 'spec_helper'

describe 'cinder::db::mysql' do

  let :req_params do
    {:password => 'pw'}
  end

  let :facts do
    {:osfamily => 'Debian'}
  end

  let :pre_condition do
    'include mysql::server'
  end

  describe 'with only required params' do
    let :params do
      req_params
    end
    it { should contain_mysql__db('cinder').with(
      :user         => 'cinder',
      :password     => 'pw',
      :host         => '127.0.0.1',
      :charset      => 'latin1'
     ) }
  end
end
