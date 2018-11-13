require 'spec_helper'

describe 'cinder::backend::vmdk' do
  let(:title) { 'hippo' }

  let :params do
    {
      :host_ip                     => '172.16.16.16',
      :host_password               => 'asdf',
      :host_username               => 'user',
      :api_retry_count             => '<SERVICE DEFAULT>',
      :max_object_retrieval        => '<SERVICE DEFAULT>',
      :image_transfer_timeout_secs => '<SERVICE DEFAULT>'
    }
  end

  let :optional_params do
    {
      :volume_folder               => 'cinder-volume-folder',
      :api_retry_count             => 5,
      :max_object_retrieval        => 200,
      :task_poll_interval          => 10,
      :image_transfer_timeout_secs => 3600,
      :backend_availability_zone   => 'my_zone',
      :wsdl_location               => 'http://127.0.0.1:8080/vmware/SDK/wsdl/vim25/vimService.wsdl'
    }
  end

  shared_examples 'cinder::backend::vmdk' do
    it {
      should contain_cinder_config('hippo/volume_backend_name').with_value('hippo')
      should contain_cinder_config('hippo/volume_driver').with_value('cinder.volume.drivers.vmware.vmdk.VMwareVcVmdkDriver')
      should contain_cinder_config('hippo/vmware_host_ip').with_value(params[:host_ip])
      should contain_cinder_config('hippo/vmware_host_username').with_value(params[:host_username])
      should contain_cinder_config('hippo/vmware_host_password').with_value(params[:host_password]).with_secret(true)
      should contain_cinder_config('hippo/vmware_volume_folder').with_value('cinder-volumes')
      should contain_cinder_config('hippo/vmware_api_retry_count').with_value(params[:api_retry_count])
      should contain_cinder_config('hippo/vmware_max_object_retrieval').with_value(params[:max_object_retrieval])
      should contain_cinder_config('hippo/vmware_task_poll_interval').with_value(5)
      should contain_cinder_config('hippo/vmware_image_transfer_timeout_secs').with_value(params[:image_transfer_timeout_secs])
      should contain_cinder_config('hippo/vmware_wsdl_location').with_value('<SERVICE DEFAULT>')
      should contain_cinder_config('hippo/backend_availability_zone').with_value('<SERVICE DEFAULT>')
    }

    it { should contain_package('python-suds').with_ensure('present') }

    context 'with optional parameters' do
      before :each do
        params.merge!(optional_params)
      end

      it {
        should contain_cinder_config('hippo/backend_availability_zone').with_value(params[:backend_availability_zone])
        should contain_cinder_config('hippo/vmware_volume_folder').with_value(params[:volume_folder])
        should contain_cinder_config('hippo/vmware_api_retry_count').with_value(params[:api_retry_count])
        should contain_cinder_config('hippo/vmware_max_object_retrieval').with_value(params[:max_object_retrieval])
        should contain_cinder_config('hippo/vmware_task_poll_interval').with_value(params[:task_poll_interval])
        should contain_cinder_config('hippo/vmware_image_transfer_timeout_secs').with_value(params[:image_transfer_timeout_secs])
        should contain_cinder_config('hippo/vmware_wsdl_location').with_value(params[:wsdl_location])
        should contain_cinder_config('hippo/backend_availability_zone').with_value(params[:backend_availability_zone])
        should contain_cinder_config('hippo/host').with_value("vmdk:#{params[:host_ip]}-#{params[:volume_folder]}")
      }
    end

    context 'vmdk backend with additional configuration' do
      before do
        params.merge!( :extra_options => {'hippo/param1' => { 'value' => 'value1' }} )
      end

      it { should contain_cinder_config('hippo/param1').with_value('value1') }
    end

    context 'vmdk backend with cinder type' do
      before do
        params.merge!( :manage_volume_type => true )
      end

      it { should contain_cinder_type('hippo').with(
        :ensure     => 'present',
        :properties => ['volume_backend_name=hippo']
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

      it_behaves_like 'cinder::backend::vmdk'
    end
  end
end
