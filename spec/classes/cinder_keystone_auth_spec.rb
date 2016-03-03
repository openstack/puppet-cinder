require 'spec_helper'

describe 'cinder::keystone::auth' do

  let :params do
    {:password => 'pw'}
  end

  context 'with required parameters' do

    it 'configures keystone user and service' do

      is_expected.to contain_keystone_user('cinder').with(
        :ensure   => 'present',
        :password => 'pw',
        :email    => 'cinder@localhost',
      )
      is_expected.to contain_keystone_user_role('cinder@services').with(
        :ensure  => 'present',
        :roles   => ['admin']
      )
      is_expected.to contain_keystone_service('cinder::volume').with(
        :ensure      => 'present',
        :description => 'Cinder Service'
      )
      is_expected.to contain_keystone_service('cinderv2::volumev2').with(
        :ensure      => 'present',
        :description => 'Cinder Service v2'
      )
      is_expected.to contain_keystone_service('cinderv3::volumev3').with(
        :ensure      => 'present',
        :description => 'Cinder Service v3'
      )

    end

    it 'configures keystone endpoints' do
      is_expected.to contain_keystone_endpoint('RegionOne/cinder::volume').with(
        :ensure       => 'present',
        :public_url   => 'http://127.0.0.1:8776/v1/%(tenant_id)s',
        :admin_url    => 'http://127.0.0.1:8776/v1/%(tenant_id)s',
        :internal_url => 'http://127.0.0.1:8776/v1/%(tenant_id)s'
      )

      is_expected.to contain_keystone_endpoint('RegionOne/cinderv2::volumev2').with(
        :ensure       => 'present',
        :public_url   => 'http://127.0.0.1:8776/v2/%(tenant_id)s',
        :admin_url    => 'http://127.0.0.1:8776/v2/%(tenant_id)s',
        :internal_url => 'http://127.0.0.1:8776/v2/%(tenant_id)s'
      )

      is_expected.to contain_keystone_endpoint('RegionOne/cinderv3::volumev3').with(
        :ensure       => 'present',
        :public_url   => 'http://127.0.0.1:8776/v3/%(tenant_id)s',
        :admin_url    => 'http://127.0.0.1:8776/v3/%(tenant_id)s',
        :internal_url => 'http://127.0.0.1:8776/v3/%(tenant_id)s'
      )
    end
  end

  context 'when overriding parameters' do
     before do
       params.merge!({
         :region          => 'RegionThree',
         :public_url      => 'https://10.0.42.1:4242/v41/%(tenant_id)s',
         :admin_url       => 'https://10.0.42.2:4242/v41/%(tenant_id)s',
         :internal_url    => 'https://10.0.42.3:4242/v41/%(tenant_id)s',
         :public_url_v2   => 'https://10.0.42.1:4242/v42/%(tenant_id)s',
         :admin_url_v2    => 'https://10.0.42.2:4242/v42/%(tenant_id)s',
         :internal_url_v2 => 'https://10.0.42.3:4242/v42/%(tenant_id)s',
         :public_url_v3   => 'https://10.0.42.1:4242/v43/%(tenant_id)s',
         :admin_url_v3    => 'https://10.0.42.2:4242/v43/%(tenant_id)s',
         :internal_url_v3 => 'https://10.0.42.3:4242/v43/%(tenant_id)s'
       })
     end

     it 'configures keystone endpoints' do
       is_expected.to contain_keystone_endpoint('RegionThree/cinder::volume').with(
         :ensure       => 'present',
         :public_url   => 'https://10.0.42.1:4242/v41/%(tenant_id)s',
         :admin_url    => 'https://10.0.42.2:4242/v41/%(tenant_id)s',
         :internal_url => 'https://10.0.42.3:4242/v41/%(tenant_id)s'
       )

       is_expected.to contain_keystone_endpoint('RegionThree/cinderv2::volumev2').with(
         :ensure       => 'present',
         :public_url   => 'https://10.0.42.1:4242/v42/%(tenant_id)s',
         :admin_url    => 'https://10.0.42.2:4242/v42/%(tenant_id)s',
         :internal_url => 'https://10.0.42.3:4242/v42/%(tenant_id)s'
       )

       is_expected.to contain_keystone_endpoint('RegionThree/cinderv3::volumev3').with(
         :ensure       => 'present',
         :public_url   => 'https://10.0.42.1:4242/v43/%(tenant_id)s',
         :admin_url    => 'https://10.0.42.2:4242/v43/%(tenant_id)s',
         :internal_url => 'https://10.0.42.3:4242/v43/%(tenant_id)s'
       )
     end
  end

  describe 'when endpoint is_expected.to not be configured' do
     before do
       params.merge!(
        :configure_endpoint    => false,
        :configure_endpoint_v2 => false,
        :configure_endpoint_v3 => false
      )
    end
    it { is_expected.to_not contain_keystone_endpoint('RegionOne/cinder::volume') }
    it { is_expected.to_not contain_keystone_endpoint('RegionOne/cinderv2::volumev2') }
    it { is_expected.to_not contain_keystone_endpoint('RegionOne/cinderv3::volumev3') }
  end

  describe 'when user is_expected.to not be configured' do
    before do
      params.merge!(
        :configure_user => false
      )
    end

    it { is_expected.to_not contain_keystone_user('cinder') }
    it { is_expected.to contain_keystone_user_role('cinder@services') }
    it { is_expected.to contain_keystone_service('cinder::volume').with(
        :ensure      => 'present',
        :description => 'Cinder Service'
    ) }

  end

  describe 'when user and user role is_expected.to not be configured' do
    before do
       params.merge!(
        :configure_user      => false,
        :configure_user_role => false
      )
    end

    it { is_expected.to_not contain_keystone_user('cinder') }
    it { is_expected.to_not contain_keystone_user_role('cinder@services') }
    it { is_expected.to contain_keystone_service('cinder::volume').with(
        :ensure      => 'present',
        :description => 'Cinder Service'
    ) }

  end

  describe 'when user and user role for v2 is_expected.to be configured' do
    before do
       params.merge!(
        :configure_user_v2      => true,
        :configure_user_role_v2 => true,
      )
    end

    it { is_expected.to contain_keystone__resource__service_identity('cinderv2').with(
      :configure_user      => true,
      :configure_user_role => true,
      :email               => 'cinderv2@localhost',
      :tenant              => 'services'
    ) }

  end

  describe 'when user and user role for v3 is_expected.to be configured' do
    before do
       params.merge!(
        :configure_user_v3      => true,
        :configure_user_role_v3 => true,
      )
    end

    it { is_expected.to contain_keystone__resource__service_identity('cinderv3').with(
      :configure_user      => true,
      :configure_user_role => true,
      :email               => 'cinderv3@localhost',
      :tenant              => 'services'
    ) }

  end

  describe 'when overriding service names' do

    before do
       params.merge!(
        :service_name    => 'cinder_service',
        :service_name_v2 => 'cinder_service_v2',
        :service_name_v3 => 'cinder_service_v3',
      )
    end

    it { is_expected.to contain_keystone_user('cinder') }
    it { is_expected.to contain_keystone_user_role('cinder@services') }
    it { is_expected.to contain_keystone_service('cinder_service::volume') }
    it { is_expected.to contain_keystone_service('cinder_service_v2::volumev2') }
    it { is_expected.to contain_keystone_service('cinder_service_v3::volumev3') }
    it { is_expected.to contain_keystone_endpoint('RegionOne/cinder_service::volume') }
    it { is_expected.to contain_keystone_endpoint('RegionOne/cinder_service_v2::volumev2') }
    it { is_expected.to contain_keystone_endpoint('RegionOne/cinder_service_v3::volumev3') }

  end

end
