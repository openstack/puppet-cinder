#Author: Andrew Woodward <awoodward@mirantis.com>

require 'spec_helper'

describe 'cinder::type_set' do

  let(:title) {'hippo'}

  let :default_params do {
    :type           => 'sith',
    :key            => 'monchichi',
    :os_password    => 'asdf',
    :os_tenant_name => 'admin',
    :os_username    => 'admin',
    :os_auth_url    => 'http://127.127.127.1:5000/v2.0/',
  }
  end

  describe 'by default' do
    let(:params){ default_params }
    it 'should have its execs' do
      should contain_exec('cinder type-key sith set monchichi=hippo').with(
        :command => 'cinder type-key sith set monchichi=hippo',
        :unless  => "cinder extra-specs-list | grep -Eq '\\bsith\\b.*\\bmonchichi\\b.*\\bhippo\\b'",
        :environment => [
          'OS_TENANT_NAME=admin',
          'OS_USERNAME=admin',
          'OS_PASSWORD=asdf',
          'OS_AUTH_URL=http://127.127.127.1:5000/v2.0/'],
        :require => 'Package[python-cinderclient]')
    end
  end

  describe 'with a different value' do
    let(:params){
      default_params.merge({:value => 'hippi'})
    }
    it 'should have its execs' do
      should contain_exec('cinder type-key sith set monchichi=hippi').with(
        :command => 'cinder type-key sith set monchichi=hippi',
        :unless  => "cinder extra-specs-list | grep -Eq '\\bsith\\b.*\\bmonchichi\\b.*\\bhippi\\b'",
        :environment => [
          'OS_TENANT_NAME=admin',
          'OS_USERNAME=admin',
          'OS_PASSWORD=asdf',
          'OS_AUTH_URL=http://127.127.127.1:5000/v2.0/'],
        :require => 'Package[python-cinderclient]')
    end
  end
end
