require 'spec_helper'

describe 'cinder::backend::hpelefthand_iscsi' do
  let (:title) { 'hpelefthand_iscsi' }

  let :req_params do
    {
      :hpelefthand_api_url     => 'https://10.206.219.18:8081/lhos',
      :hpelefthand_username    => 'admin',
      :hpelefthand_password    => 'password',
      :hpelefthand_clustername => 'nfvsys_clust_001',
    }
  end

  let :params do
    req_params
  end

  describe 'hpelefthand_iscsi volume driver' do
    it 'configure hpelefthand_iscsi volume driver' do
      is_expected.to contain_cinder_config('hpelefthand_iscsi/volume_driver').with_value('cinder.volume.drivers.hpe.hpe_lefthand_iscsi.HPELeftHandISCSIDriver')
      is_expected.to contain_cinder_config('hpelefthand_iscsi/hpelefthand_api_url').with_value('https://10.206.219.18:8081/lhos')
      is_expected.to contain_cinder_config('hpelefthand_iscsi/hpelefthand_username').with_value('admin')
      is_expected.to contain_cinder_config('hpelefthand_iscsi/hpelefthand_password').with_value('password')
      is_expected.to contain_cinder_config('hpelefthand_iscsi/hpelefthand_clustername').with_value('nfvsys_clust_001')
    end
  end

  describe 'hpelefthand_iscsi backend with additional configuration' do
    before :each do
      params.merge!({:extra_options => {'hpelefthand_iscsi/param1' => {'value' => 'value1'}}})
    end

    it 'configure hpelefthand_iscsi backend with additional configuration' do
      is_expected.to contain_cinder_config('hpelefthand_iscsi/param1').with({
        :value => 'value1',
      })
    end
  end

  describe 'hpelefthand_iscsi backend with cinder type' do
    before :each do
      params.merge!({:manage_volume_type => true})
    end
    it 'should create type with properties' do
      should contain_cinder_type('hpelefthand_iscsi').with(:ensure => :present, :properties => ['volume_backend_name=hpelefthand_iscsi'])
    end
  end

end
