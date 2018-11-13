require 'spec_helper'

describe 'cinder::backend::eqlx' do
  let (:config_group_name) { 'eqlx-1' }

  let (:title) { config_group_name }

  let :params do
    {
      :backend_availability_zone => 'my_zone',
      :san_ip                    => '192.168.100.10',
      :san_login                 => 'grpadmin',
      :san_password              => '12345',
      :san_private_key           => '',
      :volume_backend_name       => 'Dell_EQLX',
      :san_thin_provision        => '<SERVICE DEFAULT>',
      :eqlx_group_name           => '<SERVICE DEFAULT>',
      :eqlx_pool                 => 'apool',
      :use_chap_auth             => true,
      :chap_username             => 'chapadm',
      :chap_password             => '56789',
      :ssh_conn_timeout          => 31,
      :eqlx_cli_max_retries      => 6,
    }
  end

  shared_examples 'eqlx volume driver' do
    it { should contain_cinder__backend__eqlx(config_group_name) }

    it { should contain_cinder_config("#{config_group_name}/volume_driver").with(
      :value => 'cinder.volume.drivers.dell_emc.ps.PSSeriesISCSIDriver'
    )}

    it {
      params.each_pair do |config,value|
        should contain_cinder_config("#{config_group_name}/#{config}").with_value(value)
      end
    }
  end

  shared_examples 'cinder::backend::eqlx' do
    context 'eqlx backend with additional configuration' do
      before :each do
        params.merge!( :extra_options => {'eqlx-1/param1' => {'value' => 'value1'}} )
      end

      it { should contain_cinder_config('eqlx-1/param1').with_value('value1') }
    end

    context 'eqlx backend with cinder type' do
      before :each do
        params.merge!({:manage_volume_type => true})
      end

      it { should contain_cinder_type('eqlx-1').with(
        :ensure     => 'present',
        :properties => ['volume_backend_name=eqlx-1']
      )}
    end

    context 'eqlx backend with chap' do
      before :each do
        params.merge!({
          :use_chap_auth => true,
          :chap_username => 'myuser',
          :chap_password => 'mypass'
        })
      end

      it_behaves_like 'eqlx volume driver'
    end

    context 'eqlx with invalid values' do
      context 'with invalid chap_username' do
        before do
          params.merge!( :chap_username => '<SERVICE DEFAULT>' )
        end

        it { should raise_error(Puppet::Error, /chap_username need to be set./) }
      end

      context 'with invalid chap_password' do
        before do
          params.merge!( :chap_password => '<SERVICE DEFAULT>' )
        end

        it { should raise_error(Puppet::Error, /chap_password need to be set./) }
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder::backend::eqlx'
    end
  end
end
