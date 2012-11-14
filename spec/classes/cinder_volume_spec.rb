require 'spec_helper'

describe 'cinder::volume' do

  let :pre_condition do
    'class { "cinder::base": rabbit_password => "fpp", sql_connection => "mysql://a:b@c/d" }'
  end

  let :facts do
    {:osfamily => 'Debian'}
  end

  it { should contain_package('cinder-volume') }
  it { should contain_service('cinder-volume') }
end
