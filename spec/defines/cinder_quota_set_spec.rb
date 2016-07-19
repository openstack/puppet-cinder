#Author: Craig DeLatte <craig.delatte@twcable.com>

require 'spec_helper'

describe 'cinder::quota_set' do

  let(:title) {'hippo'}

  let :params do {
    :os_password     => 'asdf',
    :os_tenant_name  => 'admin',
    :os_username     => 'admin',
    :os_auth_url     => 'http://127.127.127.1:5000/v2.0/',
    :quota_volumes   => '10',
    :quota_snapshots => '10',
    :quota_gigabytes => '1000',
    :class_name      => 'default',
  }
  end

  shared_examples_for 'cinder_quota_set' do
    [{},
     { :os_region_name => 'test' }
    ].each do |param_set|
      describe "when #{param_set == {} ? 'using default' : 'specifying'} class parameters" do
        before do
          params.merge!(param_set)
        end
        it do
          is_expected.to contain_exec('cinder quota-class-update default').with(
            :command => "cinder quota-class-update default --volumes 10 --snapshots 10 --gigabytes 1000 --volume-type 'hippo'",
            :environment => (param_set == {}) ?
              ['OS_TENANT_NAME=admin',
              'OS_USERNAME=admin',
              'OS_PASSWORD=asdf',
              'OS_AUTH_URL=http://127.127.127.1:5000/v2.0/'] :
              ['OS_TENANT_NAME=admin',
              'OS_USERNAME=admin',
              'OS_PASSWORD=asdf',
              'OS_AUTH_URL=http://127.127.127.1:5000/v2.0/',
              'OS_REGION_NAME=test'],
            :onlyif      => 'cinder quota-class-show default | grep -qP -- -1',
            :require => 'Anchor[cinder-support-package]')
        end
      end
    end
  end

  context 'on Debian platforms' do
    let :facts do
      { :operatingsystem => 'Ubuntu',
        :osfamily        => 'Debian' }
    end
   it_configures 'cinder_quota_set'
  end

  context 'on Redhat platforms' do
    let :facts do
      { :operatingsystem => 'Redhat',
        :osfamily        => 'Redhat' }
    end
   it_configures 'cinder_quota_set'
  end
end
