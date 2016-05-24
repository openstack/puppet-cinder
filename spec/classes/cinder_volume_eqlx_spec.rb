require 'spec_helper'

describe 'cinder::volume::eqlx' do

  let :params do {
      :san_ip               => '192.168.100.10',
      :san_login            => 'grpadmin',
      :san_password         => '12345',
      :san_thin_provision   => true,
      :eqlx_group_name      => 'group-a',
      :eqlx_pool            => 'apool',
      :use_chap_auth        => true,
      :chap_username        => 'chapadm',
      :chap_password        => '56789',
      :ssh_conn_timeout     => 31,
      :eqlx_cli_max_retries => 6,
  }
  end

  let :facts do
    OSDefaults.get_facts({})
  end

  describe 'eqlx volume driver' do
    it 'configures eqlx volume driver' do
      is_expected.to contain_cinder_config('DEFAULT/volume_driver').with_value('cinder.volume.drivers.eqlx.DellEQLSanISCSIDriver')
      is_expected.to contain_cinder_config('DEFAULT/volume_backend_name').with_value('DEFAULT')

      params.each_pair do |config,value|
        is_expected.to contain_cinder_config("DEFAULT/#{config}").with_value(value)
      end
    end

    it 'marks eqlx_chap_password as secret' do
      is_expected.to contain_cinder_config('DEFAULT/chap_password').with_secret( true )
    end

  end

  describe 'eqlx volume driver with additional configuration' do
    before :each do
      params.merge!({:extra_options => {'eqlx_backend/param1' => {'value' => 'value1'}}})
    end

    it 'configure eqlx volume with additional configuration' do
      is_expected.to contain_cinder__backend__eqlx('DEFAULT').with({
        :extra_options => {'eqlx_backend/param1' => {'value' => 'value1'}}
      })
    end
  end

  describe 'eqlx volume driver with deprecated parameters' do
    before :each do
      params.merge!(
        :eqlx_chap_login    => 'eqlxlogin',
        :eqlx_chap_password => 'eqlxpass',
        :eqlx_use_chap      => true,
        :eqlx_cli_timeout   => 30,
      )
    end
    it 'configure eqlx volume with deprecated parameters values' do
      is_expected.to contain_cinder_config('DEFAULT/chap_username').with_value(params[:eqlx_chap_login])
      is_expected.to contain_cinder_config('DEFAULT/chap_password').with_value(params[:eqlx_chap_password])
      is_expected.to contain_cinder_config('DEFAULT/use_chap_auth').with_value(params[:eqlx_use_chap])
      is_expected.to contain_cinder_config('DEFAULT/ssh_conn_timeout').with_value(params[:eqlx_cli_timeout])
    end
  end

  describe 'eqlx with invalid values' do
    it 'should fail with chap_username with default value' do
      params[:chap_username] = '<SERVICE DEFAULT>'
      is_expected.to raise_error(Puppet::Error, /chap_username need to be set./)
    end
    it 'should fail with chap_password with default value' do
      params[:chap_password] = '<SERVICE DEFAULT>'
      is_expected.to raise_error(Puppet::Error, /chap_password need to be set./)
    end
  end
end
