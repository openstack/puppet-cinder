require 'spec_helper'

describe 'cinder::backend::scaleio' do
  let (:title) { 'scaleio' }

  let :params1 do
    {
      :sio_login                        => 'admin',
      :sio_password                     => 'password',
      :sio_server_hostname              => 'scaleio.example.com',
      :sio_server_port                  => '443',
      :manage_volume_type               => true,
      :sio_thin_provision               => false,
    }
  end

  let :params2 do
    {
      :sio_server_certificate_path      => '/path/cert.pem',
      :sio_max_over_subscription_ratio  => '6.0',
      :sio_verify_server_certificate    => true,
      :sio_storage_pool_id              => 'poolid1',
      :sio_storage_pools                => 'domain1:pool1,domain2:pool2',
      :sio_storage_pool_name            => 'pool1',
      :sio_protection_domain_id         => 'domainid1',
      :sio_protection_domain_name       => 'domain1',
      :sio_unmap_volume_before_deletion => false,
      :sio_round_volume_capacity        => true,
    }
  end

  let :params do
    params1.merge(params2)
  end

  describe 'scaleio volume driver' do
    it 'configures scaleio volume driver' do
      is_expected.to contain_cinder_config("#{title}/volume_driver").with_value(
            'cinder.volume.drivers.emc.scaleio.ScaleIODriver')
      is_expected.to contain_cinder_config("#{title}/san_login").with_value('admin')
      is_expected.to contain_cinder_config("#{title}/san_ip").with_value('scaleio.example.com')
      is_expected.to contain_cinder_config("#{title}/san_thin_provision").with_value('false')
      is_expected.to contain_cinder_config("#{title}/sio_rest_server_port").with_value('443')
      params2.each_pair do |config,value|
        is_expected.to contain_cinder_config("#{title}/#{config}").with_value(value)
      end
    end

    it 'marks sio_password as secret' do
      is_expected.to contain_cinder_config("#{title}/san_password").with_secret( true )
    end
  end

  describe 'scaleio backend with additional configuration' do
    before :each do
      params.merge!({:extra_options => {"#{title}/param1" => {'value' => 'value1'}}})
    end

    it 'configure scaleio backend with additional configuration' do
      is_expected.to contain_cinder_config("#{title}/param1").with({
        :value => 'value1',
      })
    end
  end

  describe 'scaleio backend with cinder type' do
    before :each do
      params.merge!({:manage_volume_type => true})
    end
    it 'should create type with properties' do
      should contain_cinder_type("#{title}").with(
            :ensure => :present, :properties => ["volume_backend_name=#{title}"])
    end
  end

end

