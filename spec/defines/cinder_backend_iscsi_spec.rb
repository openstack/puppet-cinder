require 'spec_helper'

describe 'cinder::backend::iscsi' do
  let(:title) {'hippo'}

  let :req_params do
    {
      :target_ip_address => '127.0.0.2',
      :target_helper     => 'tgtadm',
    }
  end

  let :params do
    req_params
  end

  let :iser_params do
    {
      :target_protocol => 'iser'
    }
  end

  let :volumes_dir_params do
    {
      :volumes_dir => '/etc/cinder/volumes'
    }
  end

  shared_examples 'cinder::backend::iscsi' do
    context 'with default params' do
      it {
        is_expected.to contain_cinder_config('hippo/volume_backend_name').with_value('hippo')
        is_expected.to contain_cinder_config('hippo/backend_availability_zone').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hippo/volume_driver').with_value('cinder.volume.drivers.lvm.LVMVolumeDriver')
        is_expected.to contain_cinder_config('hippo/target_ip_address').with_value('127.0.0.2')
        is_expected.to contain_cinder_config('hippo/target_helper').with_value('tgtadm')
        is_expected.to contain_cinder_config('hippo/volume_group').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hippo/volumes_dir').with_value('/var/lib/cinder/volumes')
        is_expected.to contain_cinder_config('hippo/target_protocol').with_value('<SERVICE DEFAULT>')
      }
    end

    context 'with iser protocol' do
      before :each do
        params.merge!(iser_params)
      end

      it { is_expected.to contain_cinder_config('hippo/target_protocol').with_value('iser') }
    end

    context 'with non-default volumes_dir' do
      before :each do
        params.merge!(volumes_dir_params)
      end

      it { is_expected.to contain_cinder_config('hippo/volumes_dir').with_value('/etc/cinder/volumes') }
    end

    context 'iscsi backend with cinder type' do
      before :each do
        params.merge!( :manage_volume_type => true )
      end

      it { is_expected.to contain_cinder_type('hippo').with(
        :ensure     => 'present',
        :properties => ['volume_backend_name=hippo']
      )}
    end

    context 'iscsi backend with additional configuration' do
      before :each do
        params.merge!( :extra_options => {'hippo/param1' => {'value' => 'value1'}} )
      end

      it { is_expected.to contain_cinder_config('hippo/param1').with(
        :value => 'value1',
      )}
    end

    context 'with deprecated iscsi_ip_address' do
      before :each do
        params.merge!({
          :target_ip_address => :undef,
          :iscsi_ip_address  => '127.0.0.42',
        })
      end

      it { is_expected.to contain_cinder_config('hippo/target_ip_address').with_value('127.0.0.42') }
    end

    context 'with no target_ip_address or iscsi_ip_address' do
      before :each do
        params.delete(:target_ip_address)
      end

      it { is_expected.to raise_error(Puppet::Error, /A target_ip_address or iscsi_ip_address must be specified./) }
    end
  end

  shared_examples 'cinder::backend::iscsi on RedHat' do
    it { is_expected.to contain_file_line('cinder include').with(
      :line => 'include /var/lib/cinder/volumes/*',
      :path => '/etc/tgt/targets.conf'
    )}
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder::backend::iscsi'

      if facts[:osfamily] == 'RedHat'
        it_behaves_like 'cinder::backend::iscsi on RedHat'
      end
    end
  end
end
