require 'spec_helper'

describe 'cinder::backend::nexenta_edge' do
  let (:title) { 'nexenta_edge' }

  let :params do
    { :nexenta_rest_user      => 'nexenta',
      :nexenta_rest_password  => 'password',
      :nexenta_rest_address   => '127.0.0.2',
      :nexenta_client_address => '127.0.0.3' }
  end

  let :default_params do
    { :nexenta_rest_port     => '8080',
      :nexenta_lun_container => 'cinder',
      :nexenta_iscsi_service => 'cinder',
      :nexenta_chunksize     => '32768',
      :volume_driver         => 'cinder.volume.drivers.nexenta.nexentaedge.iscsi.NexentaEdgeISCSIDriver' }
  end

  let :facts do
    OSDefaults.get_facts({})
  end


  context 'with required params' do
    let :params_hash do
      default_params.merge(params)
    end

    it 'configures nexenta edge volue driver' do
      params_hash.each_pair do |config, value|
        is_expected.to contain_cinder_config("nexenta_edge/#{config}").with_value(value)
      end
    end
  end

  context 'nexenta edge backend with additional configuration' do
    before do
      params.merge!({:extra_options => {'nexenta_edge/param1' => { 'value' => 'value1' }}})
    end

    it 'configure nexenta edge backend with additional configuration' do
      is_expected.to contain_cinder_config('nexenta_edge/param1').with({
        :value => 'value1'
      })
    end
  end

  context 'nexenta edge backend with cinder type' do
    before do
      params.merge!({:manage_volume_type => true})
    end
    it 'should create type with properties' do
      should contain_cinder_type('nexenta_edge').with(:ensure => :present, :properties => ['volume_backend_name=nexenta_edge'])
    end
  end

end
