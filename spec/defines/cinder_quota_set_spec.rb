#Author: Craig DeLatte <craig.delatte@twcable.com>

require 'spec_helper'

describe 'cinder::quota_set' do
  let(:title) {'hippo'}

  let :params do
    {
      :os_password     => 'asdf',
      :os_tenant_name  => 'admin',
      :os_username     => 'admin',
      :os_auth_url     => 'http://127.127.127.1:5000/v3/',
      :quota_volumes   => '10',
      :quota_snapshots => '10',
      :quota_gigabytes => '1000',
      :class_name      => 'default',
    }
  end

  shared_examples 'cinder::quota_set' do
    context 'with specified parameters' do
      it { is_expected.to contain_exec('openstack quota set --class default').with(
        :command     => "openstack quota set --class default --volumes 10 --snapshots 10 --gigabytes 1000 --volume-type 'hippo'",
        :environment => [
          'OS_TENANT_NAME=admin',
          'OS_USERNAME=admin',
          'OS_PASSWORD=asdf',
          'OS_AUTH_URL=http://127.127.127.1:5000/v3/',
        ],
        :onlyif      => 'openstack quota show --class default | grep -qP -- -1',
        :require     => 'Anchor[cinder::install::end]',
      )}
    end

    context 'with region name set' do
      before do
        params.merge!( :os_region_name => 'test' )
      end

      it { is_expected.to contain_exec('openstack quota set --class default').with(
        :command     => "openstack quota set --class default --volumes 10 --snapshots 10 --gigabytes 1000 --volume-type 'hippo'",
        :environment => [
          'OS_TENANT_NAME=admin',
          'OS_USERNAME=admin',
          'OS_PASSWORD=asdf',
          'OS_AUTH_URL=http://127.127.127.1:5000/v3/',
          'OS_REGION_NAME=test',
        ],
        :onlyif      => 'openstack quota show --class default | grep -qP -- -1',
        :require     => 'Anchor[cinder::install::end]',
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder::quota_set'
    end
  end
end
