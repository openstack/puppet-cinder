require 'spec_helper'

describe 'cinder::backend::hpe3par_iscsi' do
  let (:title) { 'hpe3par_iscsi' }

  let :req_params do
    {
      :hpe3par_api_url           => 'https://172.0.0.2:8080/api/v1',
      :hpe3par_username          => '3paradm',
      :hpe3par_password          => 'password',
      :hpe3par_iscsi_ips         => '172.0.0.3',
      :san_ip                    => '172.0.0.2',
      :san_login                 => '3paradm',
      :san_password              => 'password',
    }
  end

  let :params do
    req_params
  end

  shared_examples 'cinder::backend::hpe3par_iscsi' do
    context 'with default parameters' do
      it {
        is_expected.to contain_cinder_config('hpe3par_iscsi/volume_driver').with_value('cinder.volume.drivers.hpe.hpe_3par_iscsi.HPE3PARISCSIDriver')
        is_expected.to contain_cinder_config('hpe3par_iscsi/backend_availability_zone').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hpe3par_iscsi/image_volume_cache_enabled').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hpe3par_iscsi/image_volume_cache_max_size_gb').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hpe3par_iscsi/image_volume_cache_max_count').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hpe3par_iscsi/reserved_percentage').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hpe3par_iscsi/max_over_subscription_ratio').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hpe3par_iscsi/hpe3par_api_url').with_value('https://172.0.0.2:8080/api/v1')
        is_expected.to contain_cinder_config('hpe3par_iscsi/hpe3par_username').with_value('3paradm')
        is_expected.to contain_cinder_config('hpe3par_iscsi/hpe3par_password').with_value('password')
        is_expected.to contain_cinder_config('hpe3par_iscsi/hpe3par_iscsi_ips').with_value('172.0.0.3')
        is_expected.to contain_cinder_config('hpe3par_iscsi/san_ip').with_value('172.0.0.2')
        is_expected.to contain_cinder_config('hpe3par_iscsi/san_login').with_value('3paradm')
        is_expected.to contain_cinder_config('hpe3par_iscsi/san_password').with_value('password')
      }
    end

    context 'with parameters' do
      before :each do
        params.merge!({
          :backend_availability_zone   => 'my_zone',
          :reserved_percentage         => 10,
          :max_over_subscription_ratio => 1.5,
        })
      end
      it {
        is_expected.to contain_cinder_config('hpe3par_iscsi/backend_availability_zone').with_value('my_zone')
        is_expected.to contain_cinder_config('hpe3par_iscsi/reserved_percentage').with_value(10)
        is_expected.to contain_cinder_config('hpe3par_iscsi/max_over_subscription_ratio').with_value(1.5)
      }
    end

    context 'hpe3par_iscsi backend with additional configuration' do
      before :each do
        params.merge!( :extra_options => {'hpe3par_iscsi/param1' => {'value' => 'value1'}} )
      end

      it { is_expected.to contain_cinder_config('hpe3par_iscsi/param1').with_value('value1') }
    end

    context 'hpe3par_iscsi backend with cinder type' do
      before :each do
        params.merge!( :manage_volume_type => true )
      end

      it { is_expected.to contain_cinder_type('hpe3par_iscsi').with(
        :ensure     => 'present',
        :properties => ['volume_backend_name=hpe3par_iscsi']
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder::backend::hpe3par_iscsi'
    end
  end
end
