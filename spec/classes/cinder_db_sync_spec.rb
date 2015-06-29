require 'spec_helper'

describe 'cinder::db::sync' do

  shared_examples_for 'cinder-dbsync' do

    it 'runs cinder-manage db_sync' do
      is_expected.to contain_exec('cinder-manage db_sync').with(
        :command     => 'cinder-manage db sync',
        :user        => 'cinder',
        :path        => '/usr/bin',
        :refreshonly => 'true',
        :logoutput   => 'on_failure'
      )
    end

  end

  context 'on a RedHat osfamily' do
    let :facts do
      {
        :osfamily                 => 'RedHat',
        :operatingsystemrelease   => '7.0',
        :concat_basedir => '/var/lib/puppet/concat'
      }
    end

    it_configures 'cinder-dbsync'
  end

  context 'on a Debian osfamily' do
    let :facts do
      {
        :operatingsystemrelease => '7.8',
        :operatingsystem        => 'Debian',
        :osfamily               => 'Debian',
        :concat_basedir => '/var/lib/puppet/concat'
      }
    end

    it_configures 'cinder-dbsync'
  end

end
