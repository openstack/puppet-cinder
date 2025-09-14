require 'spec_helper'

describe 'cinder::nova' do
  shared_examples 'cinder::nova' do
    let :params do
      { :password => 'novapass' }
    end

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
        is_expected.to contain_cinder_config('nova/auth_type').with_value('password')
        is_expected.to contain_cinder_config('nova/auth_url').with_value('http://127.0.0.1:5000')
        is_expected.to contain_cinder_config('nova/username').with_value('nova')
        is_expected.to contain_cinder_config('nova/user_domain_name').with_value('Default')
        is_expected.to contain_cinder_config('nova/password').with_value('novapass').with_secret(true)
        is_expected.to contain_cinder_config('nova/project_name').with_value('services')
        is_expected.to contain_cinder_config('nova/project_domain_name').with_value('Default')
        is_expected.to contain_cinder_config('nova/system_scope').with_value('<SERVICE DEFAULT>')
      }
    end

    context 'with specified parameters' do
      before :each do
        params.merge!({
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
          :auth_type      => 'v3password',
          :auth_url       => 'http://127.0.0.2:5000',
        })
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
        is_expected.to contain_cinder_config('nova/auth_type').with_value('v3password')
        is_expected.to contain_cinder_config('nova/auth_url').with_value('http://127.0.0.2:5000')
        is_expected.to contain_cinder_config('nova/username').with_value('nova')
        is_expected.to contain_cinder_config('nova/user_domain_name').with_value('Default')
        is_expected.to contain_cinder_config('nova/password').with_value('novapass').with_secret(true)
        is_expected.to contain_cinder_config('nova/project_name').with_value('services')
        is_expected.to contain_cinder_config('nova/project_domain_name').with_value('Default')
        is_expected.to contain_cinder_config('nova/system_scope').with_value('<SERVICE DEFAULT>')
      }
    end

    context 'with system_scope set' do
      before :each do
        params.merge!({
          :system_scope => 'all'
        })
      end

      it {
        is_expected.to contain_cinder_config('nova/project_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('nova/project_domain_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('nova/system_scope').with_value('all')
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
