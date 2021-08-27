require 'spec_helper'

describe 'cinder::keystone::service_user' do

  let :params do
    {
      :password => 'cinder_password',
    }
  end

  shared_examples 'cinder service_user' do

    context 'with default parameters' do

      it 'configure service_user' do
        is_expected.to contain_keystone__resource__service_user('cinder_config').with(
          :username                => 'cinder',
          :password                => 'cinder_password',
          :auth_url                => 'http://localhost:5000',
          :project_name            => 'services',
          :user_domain_name        => 'Default',
          :project_domain_name     => 'Default',
          :insecure                => '<SERVICE DEFAULT>',
          :send_service_user_token => false,
          :auth_type               => 'password',
          :auth_version            => '<SERVICE DEFAULT>',
          :cafile                  => '<SERVICE DEFAULT>',
          :certfile                => '<SERVICE DEFAULT>',
          :keyfile                 => '<SERVICE DEFAULT>',
          :region_name             => '<SERVICE DEFAULT>',
        )
      end
    end

    context 'when overriding parameters' do
      before do
        params.merge!({
          :username                => 'myuser',
          :password                => 'mypasswd',
          :auth_url                => 'http://127.0.0.1:5000',
          :project_name            => 'service_project',
          :user_domain_name        => 'domainX',
          :project_domain_name     => 'domainX',
          :send_service_user_token => true,
          :insecure                => false,
          :auth_type               => 'password',
          :auth_version            => 'v3',
          :cafile                  => '/opt/stack/data/cafile.pem',
          :certfile                => 'certfile.crt',
          :keyfile                 => 'keyfile',
          :region_name             => 'region2',
        })
      end

      it 'configure service_user' do
        is_expected.to contain_keystone__resource__service_user('cinder_config').with(
          :username                => 'myuser',
          :password                => 'mypasswd',
          :auth_url                => 'http://127.0.0.1:5000',
          :project_name            => 'service_project',
          :user_domain_name        => 'domainX',
          :project_domain_name     => 'domainX',
          :send_service_user_token => true,
          :insecure                => false,
          :auth_type               => 'password',
          :auth_version            => 'v3',
          :cafile                  => '/opt/stack/data/cafile.pem',
          :certfile                => 'certfile.crt',
          :keyfile                 => 'keyfile',
          :region_name             => 'region2',
        )
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder service_user'
    end
  end

end
