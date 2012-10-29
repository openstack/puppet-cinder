require 'spec_helper'

describe 'cinder::keystone::auth' do

  let :req_params do
    {:password => 'pw'}
  end

  describe 'with only required params' do

    let :params do
      req_params
    end

    it 'should contain auth info' do

      should contain_keystone_user('cinder').with(
        :ensure   => 'present',
        :password => 'pw',
        :email    => 'cinder@localhost',
        :tenant   => 'services'
      )
      should contain_keystone_user_role('cinder@services').with(
        :ensure  => 'present',
        :roles   => 'admin'
      )
      should contain_keystone_service('cinder').with(
        :ensure      => 'present',
        :type        => 'volume',
        :description => 'Cinder Service'
      )

    end
    it { should contain_keystone_endpoint('RegionOne/cinder').with(
      :ensure       => 'present',
      :public_url   => 'http://127.0.0.1:8776/v1/%(tenant_id)s',
      :admin_url    => 'http://127.0.0.1:8776/v1/%(tenant_id)s',
      :internal_url => 'http://127.0.0.1:8776/v1/%(tenant_id)s'
    ) }

  end

  describe 'when endpoint should not be configured' do
    let :params do
      req_params.merge(:configure_endpoint => false)
    end
    it { should_not contain_keystone_endpoint('RegionOne/cinder') }
  end

end
