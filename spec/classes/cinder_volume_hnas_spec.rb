require 'spec_helper'

describe 'cinder::volume::hnas' do

  let :req_params do
    {
      :volume_backend_name    => 'hnas-iscsi',
      :hds_hnas_iscsi_config_file           => '/etc/cinder/cinder_iscsi_conf.xml',
    }
  end


  shared_examples_for 'hnas volume driver' do
  let :params do
    req_params
  end

    it 'configures hnas volume driver' do
      is_expected.to contain_cinder_config('DEFAULT/volume_driver').with_value('cinder.volume.drivers.hds.iscsi.HDSISCSIDriver')
      params_hash.each_pair do |config,value|
        is_expected.to contain_cinder_config('DEFAULT/#{config}').with_value( value )
      end
    end
end

  context 'with default parameters' do
    before do
      params = {}
    end

    it_configures 'hnas volume driver'
  end

  context 'with provided parameters' do
    it_configures 'hnas volume driver'
  end

  context 'with iscsi shares provided' do
    let (:req_params) { params.merge!({
        :hds_hnas_iscsi_config_file => '/etc/cinder/cinder_iscsi_conf.xml',
    }) }

    it 'writes iscsi shares to file' do
      is_expected.to contain_file("#{req_params[:hds_hnas_iscsi_config_file]}")
        .with_content("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n\n<config>\n<mgmt_ip0>172.24.44.15</mgmt_ip0>\n<username>supervisor</username>\n<password>supervisor</password>\n<enable_ssh>True</enable_ssh>\n<ssh_private_key>/home/ubuntu/.ssh/id_rsa</ssh_private_key>\n<svc_0>\n<volume_type>default</volume_type>\n<iscsi_ip>172.24.44.26</iscsi_ip>\n<hdp>dev-default</hdp>\n</svc_0>\n<svc_1>\n<volume_type>gold</volume_type>\n<iscsi_ip>172.24.44.26</iscsi_ip>\n<hdp>erlon-dev-gold</hdp>\n</svc_1>\n<svc_2>\n<volume_type>platinum</volume_type>\n<iscsi_ip>172.24.44.26</iscsi_ip>\n<hdp>dev-platinum</hdp>\n</svc_2>\n<svc_3>\n<volume_type>silver</volume_type>\n<iscsi_ip>172.24.44.26</iscsi_ip>\n<hdp>dev-silver</hdp>\n</svc_3>\n</config> ")
    end
  end

  context 'hnas volume with additional configuration' do
    before do
      params.merge!({:extra_options => {'hnas_backend/param1' => { 'value' => 'value1' }}})
    end

    it 'configure hnas volume with additional configuration' do
      should contain_cinder__backend__hnas('DEFAULT').with({
        :extra_options => {'hnas_backend/param1' => {'value' => 'value1'}}
      })  
    end
  end

end
