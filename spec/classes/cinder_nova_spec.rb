require 'spec_helper'

describe 'cinder::nova' do
  shared_examples 'cinder::nova' do
    context 'with default parameters' do
      it {
        is_expected.to contain_cinder_config('nova/region_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('nova/interface').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('nova/token_auth_url').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('nova/cafile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('nova/certfile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('nova/keyfile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('nova/insecure').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('nova/timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('nova/collect_timing').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('nova/split_loggers').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('nova/auth_type').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('nova/auth_section').with_value('<SERVICE DEFAULT>')

        # These should be added only when auth_type is 'password'
        is_expected.not_to contain_cinder_config('nova/auth_url')
        is_expected.not_to contain_cinder_config('nova/username')
        is_expected.not_to contain_cinder_config('nova/user_domain_name')
        is_expected.not_to contain_cinder_config('nova/password')
        is_expected.not_to contain_cinder_config('nova/project_name')
        is_expected.not_to contain_cinder_config('nova/project_domain_name')
      }
    end

    context 'with specified parameters' do
      let :params do
        {
          :region_name    => 'RegionOne',
          :interface      => 'internal',
          :token_auth_url => 'http://127.0.0.1:5000/v3',
          :cafile         => '/etc/ssl/certs/ca.crt',
          :certfile       => '/etc/ssl/certs/cert.crt',
          :keyfile        => '/etc/ssl/private/key.key',
          :insecure       => false,
          :timeout        => 30,
          :collect_timing => true,
          :split_loggers  => true,
          :auth_type      => 'password',
          :auth_section   => 'my_section',
          :auth_url       => 'http://127.0.0.2:5000',
          :password       => 'foo',
        }
      end

      it {
        is_expected.to contain_cinder_config('nova/region_name').with_value('RegionOne')
        is_expected.to contain_cinder_config('nova/interface').with_value('internal')
        is_expected.to contain_cinder_config('nova/token_auth_url').with_value('http://127.0.0.1:5000/v3')
        is_expected.to contain_cinder_config('nova/cafile').with_value('/etc/ssl/certs/ca.crt')
        is_expected.to contain_cinder_config('nova/certfile').with_value('/etc/ssl/certs/cert.crt')
        is_expected.to contain_cinder_config('nova/keyfile').with_value('/etc/ssl/private/key.key')
        is_expected.to contain_cinder_config('nova/insecure').with_value(false)
        is_expected.to contain_cinder_config('nova/timeout').with_value(30)
        is_expected.to contain_cinder_config('nova/collect_timing').with_value(true)
        is_expected.to contain_cinder_config('nova/split_loggers').with_value(true)
        is_expected.to contain_cinder_config('nova/auth_type').with_value('password')
        is_expected.to contain_cinder_config('nova/auth_section').with_value('my_section')
        is_expected.to contain_cinder_config('nova/auth_url').with_value('http://127.0.0.2:5000')
        is_expected.to contain_cinder_config('nova/username').with_value('nova')
        is_expected.to contain_cinder_config('nova/user_domain_name').with_value('Default')
        is_expected.to contain_cinder_config('nova/password').with_value('foo')
        is_expected.to contain_cinder_config('nova/project_name').with_value('service')
        is_expected.to contain_cinder_config('nova/project_domain_name').with_value('Default')
      }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder::nova'
    end
  end
end
