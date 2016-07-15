require 'spec_helper'

describe 'cinder::volume' do

  let :pre_condition do
    'class { "cinder": rabbit_password => "fpp", database_connection => "mysql://a:b@c/d" }'
  end

  let :facts do
    OSDefaults.get_facts({:osfamily => 'Debian'})
  end

  it { is_expected.to contain_package('cinder-volume').with_ensure('present') }
  it { is_expected.to contain_service('cinder-volume').with(
      'hasstatus' => true,
      'tag'       => 'cinder-service',
  )}
  it { is_expected.to contain_cinder_config('DEFAULT/volume_clear').with_value('<SERVICE DEFAULT>') }
  it { is_expected.to contain_cinder_config('DEFAULT/volume_clear_size').with_value('<SERVICE DEFAULT>') }
  it { is_expected.to contain_cinder_config('DEFAULT/volume_clear_ionice').with_value('<SERVICE DEFAULT>') }

  describe 'with manage_service false' do
    let :params do
      { 'manage_service' => false }
    end
    it 'should not change the state of the service' do
      is_expected.to contain_service('cinder-volume').without_ensure
    end
  end

  describe 'with volume_clear parameters' do
    let :params do
      {
        'volume_clear'        => 'none',
        'volume_clear_size'   => '10',
        'volume_clear_ionice' => '-c3',
      }
    end
    it 'should set volume_clear parameters' do
      is_expected.to contain_cinder_config('DEFAULT/volume_clear').with_value('none')
      is_expected.to contain_cinder_config('DEFAULT/volume_clear_size').with_value('10')
      is_expected.to contain_cinder_config('DEFAULT/volume_clear_ionice').with_value('-c3')
    end
  end
end
