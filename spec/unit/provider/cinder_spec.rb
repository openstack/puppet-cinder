require 'puppet'
require 'spec_helper'
require 'puppet/provider/cinder'
require 'tempfile'

klass = Puppet::Provider::Cinder

describe Puppet::Provider::Cinder do

  after :each do
    klass.reset
  end

  describe 'when retrieving the auth credentials' do

    it 'should fail if no auth params are passed and the glance config file does not have the expected contents' do
      mock = {}
      Puppet::Util::IniConfig::File.expects(:new).returns(mock)
      mock.expects(:read).with('/etc/cinder/cinder.conf')
      expect do
        klass.cinder_credentials
      end.to raise_error(Puppet::Error, /Cinder types will not work/)
    end

    it 'should read conf file with all sections' do
      creds_hash = {
        'auth_uri'            => 'https://192.168.56.210:35357/v2.0/',
        'project_name'        => 'admin_tenant',
        'username'            => 'admin',
        'password'            => 'password',
        'project_domain_name' => 'Default',
        'user_domain_name'    => 'Default',
      }
      mock = {
        'keystone_authtoken' => {
          'auth_uri'     => 'https://192.168.56.210:35357/v2.0/',
          'project_name' => 'admin_tenant',
          'username'     => 'admin',
          'password'     => 'password',
        }
      }
      Puppet::Util::IniConfig::File.expects(:new).returns(mock)
      mock.expects(:read).with('/etc/cinder/cinder.conf')
      expect(klass.cinder_credentials).to eq(creds_hash)
    end

  end
end
