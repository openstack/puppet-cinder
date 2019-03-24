require 'spec_helper'

describe 'cinder::db::sync' do
  shared_examples 'cinder-dbsync' do
    it 'runs cinder-manage db_sync' do
      is_expected.to contain_exec('cinder-manage db_sync').with(
        :command     => 'cinder-manage  db sync',
        :user        => 'cinder',
        :path        => ['/bin', '/usr/bin'],
        :refreshonly => 'true',
        :try_sleep   => 5,
        :tries       => 10,
        :logoutput   => 'on_failure',
        :subscribe   => ['Anchor[cinder::install::end]',
                         'Anchor[cinder::config::end]',
                         'Anchor[cinder::dbsync::begin]'],
        :notify      => 'Anchor[cinder::dbsync::end]',
        :tag         => 'openstack-db',
      )
    end

    context "overriding extra_params" do
      let :params do
        {
          :extra_params => '--config-file /etc/cinder/cinder.conf',
        }
      end

      it {
        is_expected.to contain_exec('cinder-manage db_sync').with(
          :command     => 'cinder-manage --config-file /etc/cinder/cinder.conf db sync',
          :user        => 'cinder',
          :path        => ['/bin', '/usr/bin'],
          :refreshonly => 'true',
          :try_sleep   => 5,
          :tries       => 10,
          :logoutput   => 'on_failure',
          :subscribe   => ['Anchor[cinder::install::end]',
                         'Anchor[cinder::config::end]',
                         'Anchor[cinder::dbsync::begin]'],
          :notify      => 'Anchor[cinder::dbsync::end]',
          :tag         => 'openstack-db',
        )
      }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :os_workers     => 8,
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end

      it_behaves_like 'cinder-dbsync'
    end
  end
end
