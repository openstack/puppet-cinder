require 'spec_helper'

describe 'cinder::scheduler' do

  let :facts do
    {:osfamily => 'Debian'}
  end
  it { should contain_package('cinder-scheduler') }
  it { should contain_service('cinder-scheduler') }
end
