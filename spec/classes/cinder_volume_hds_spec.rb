require 'spec_helper'

describe 'cinder::volume::hds' do

  let :req_params do
    {
      :volume_backend_name    => 'hnas-nfs',
      :hds_hnas_nfs_config_file           => '/etc/cinder/cinder_nfs_conf.xml',
    }
  end

  let :params do
    req_params
  end

  shared_examples_for 'hds volume driver' do
    let :params_hash do
      default_params.merge(params)
    end

    it 'configures hds volume driver' do
      is_expected.to contain_cinder_config('DEFAULT/volume_driver').with_value(
        'cinder.volume.drivers.hds.nfs.HDSNFSDriver')
      params_hash.each_pair do |config,value|
        is_expected.to contain_cinder_config("DEFAULT/#{config}").with_value( value )
      end
    end
  end

  context 'with default parameters' do
    before do
      params = {}
    end

    it_configures 'hds volume driver'
  end

  context 'with provided parameters' do
    it_configures 'hds volume driver'
  end

  context 'with nfs shares provided' do
    let (:req_params) { params.merge!({
        :hds_hnas_nfs_config_file => '/etc/cinder/cinder_nfs_conf.xml',
    }) }

    it 'writes NFS shares to file' do
      is_expected.to contain_file("#{req_params[:hds_hnas_nfs_config_file]}")
        .with_content("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n\n<config>\n <mgmt_ip0>172.24.44.15</mgmt_ip0>\n<username>supervisor</username>\n<password>supervisor</password>\n<enable_ssh>True</enable_ssh>\n<ssh_private_key>/home/ubuntu/.ssh/id_rsa</ssh_private_key>\n<svc_0>\n<volume_type>default</volume_type>\n<hdp>172.24.44.26:/default</hdp>\n</svc_0>\n<svc_1>\n<volume_type>gold</volume_type>\n<hdp>172.24.44.26:/gold</hdp>\n</svc_1>\n<svc_2>\n<volume_type>platinum</volume_type>\n<hdp>172.24.44.26:/platinum</hdp>\n</svc_2>\n<svc_3>\n<volume_type>silver</volume_type>\n<hdp>172.24.44.26:/silver</hdp>\n</svc_3>\n</config> ")
    end
  end

  context 'with hds volume drivers additional configuration' do
    before do
      params.merge!({:extra_options => {'hds_backend/param1' => { 'value' => 'value1' }}})
    end

    it 'configure hds volume with additional configuration' do
      should contain_cinder__backend__hds('DEFAULT').with({
        :extra_options => {'hds_backend/param1' => {'value' => 'value1'}}
      })  
    end
  end

 end