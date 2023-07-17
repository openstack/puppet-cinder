require 'spec_helper'

describe 'cinder::backend::ibm_svf' do
  let (:config_group_name) { 'ibm_svf' }

  let (:title) { config_group_name }

  let :params do
    {
      :san_ip                    => '127.0.0.2',
      :san_login                 => 'Admin',
      :san_password              => '12345',
      :storwize_svc_volpool_name => 'svfpool',
    }
  end

  shared_examples 'cinder::backend::ibm_svf' do
    context 'with default parameters' do
      it 'should configure an iSCSI ibm_svf backend' do
        is_expected.to contain_cinder__backend__ibm_svf(config_group_name)
        is_expected.to contain_cinder_config("#{title}/volume_driver").with_value(
          'cinder.volume.drivers.ibm.storwize_svc.storwize_svc_iscsi.StorwizeSVCISCSIDriver'
        )
        is_expected.to contain_cinder_config("#{title}/san_ip").with_value('127.0.0.2')
        is_expected.to contain_cinder_config("#{title}/san_login").with_value('Admin')
        is_expected.to contain_cinder_config("#{title}/san_password").with_value('12345')
        is_expected.to contain_cinder_config("#{title}/storwize_svc_volpool_name").with_value('svfpool')
        is_expected.to contain_cinder_config("#{title}/storwize_svc_allow_tenant_qos").with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config("#{title}/storwize_svc_iscsi_chap_enabled").with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config("#{title}/storwize_svc_retain_aux_volume").with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config("#{title}/storwize_portset").with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config("#{title}/backend_availability_zone").with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with storwize_svc_connection_protocol set to FC' do
      before do
        params.merge!(:storwize_svc_connection_protocol => 'FC',)
      end

      it 'should configure the FC driver' do
        is_expected.to contain_cinder_config("#{title}/volume_driver").with_value(
          'cinder.volume.drivers.ibm.storwize_svc.storwize_svc_fc.StorwizeSVCFCDriver'
        )
      end
    end

    context 'with an invalid storwize_svc_connection_protocol' do
      before do
        params.merge!(:storwize_svc_connection_protocol => 'BAD',)
      end

      it 'should raise an error' do
        is_expected.to compile.and_raise_error(/Evaluation Error/)
      end
    end

    context 'with custom backend_availability_zone' do
      before do
        params.merge!(:backend_availability_zone => 'my_zone')
      end

      it 'should configure the backend_availability_zone' do
        is_expected.to contain_cinder_config("#{title}/backend_availability_zone").with_value('my_zone')
      end
    end

    context 'ibm_svf backend with additional configuration' do
      before do
        params.merge!( :extra_options => {'ibm_svf/param1' => { 'value' => 'value1' }} )
      end

      it { is_expected.to contain_cinder_config('ibm_svf/param1').with_value('value1') }
    end

    context 'ibm_svf backend with cinder type' do
      before do
        params.merge!( :manage_volume_type => true )
      end

      it { is_expected.to contain_cinder_type('ibm_svf').with(
        :ensure     => 'present',
        :properties => ['volume_backend_name=ibm_svf']
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

      it_behaves_like 'cinder::backend::ibm_svf'
    end
  end
end
