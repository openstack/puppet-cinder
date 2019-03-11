require 'spec_helper'

describe 'cinder::backend::bdd' do
  let(:title) { 'hippo' }

  let :params do
    {
      :target_ip_address => '127.0.0.2',
      :available_devices => '/dev/sda',
    }
  end

  shared_examples 'cinder block device' do
    context 'with default parameters' do
      it {
        is_expected.to contain_cinder_config('hippo/volume_backend_name').with_value('hippo')
        is_expected.to contain_cinder_config('hippo/volume_driver').with_value('cinder.volume.drivers.block_device.BlockDeviceDriver')
        is_expected.to contain_cinder_config('hippo/available_devices').with_value('/dev/sda')
        is_expected.to contain_cinder_config('hippo/target_helper').with_value('tgtadm')
        is_expected.to contain_cinder_config('hippo/volumes_dir').with_value('/var/lib/cinder/volumes')
        is_expected.to contain_cinder_config('hippo/target_ip_address').with_value('127.0.0.2')
        is_expected.to contain_cinder_config('hippo/volume_group').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hippo/target_protocol').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hippo/volume_clear').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('hippo/backend_availability_zone').with_value('<SERVICE DEFAULT>')
      }
    end

    context 'with optional parameters' do
      before :each do
        params.merge!({
          :target_ip_address         => '10.20.0.2',
          :available_devices         => '/dev/sdb,/dev/sdc',
          :volumes_dir               => '/var/lib/cinder/bdd-volumes',
          :volume_clear              => 'zero',
          :volume_group              => 'cinder',
          :target_helper             => 'lioadm',
          :manage_volume_type        => true,
          :backend_availability_zone => 'my_zone',
        })
      end

      it {
        is_expected.to contain_cinder_config('hippo/available_devices').with_value('/dev/sdb,/dev/sdc')
        is_expected.to contain_cinder_config('hippo/volumes_dir').with_value('/var/lib/cinder/bdd-volumes')
        is_expected.to contain_cinder_config('hippo/target_ip_address').with_value('10.20.0.2')
        is_expected.to contain_cinder_config('hippo/target_helper').with_value('lioadm')
        is_expected.to contain_cinder_config('hippo/volume_group').with_value('cinder')
        is_expected.to contain_cinder_config('hippo/volume_clear').with_value('zero')
        is_expected.to contain_cinder_config('hippo/backend_availability_zone').with_value('my_zone')
      }

      it { is_expected.to contain_cinder_type('hippo').with(
        :ensure     => 'present',
        :properties => ['volume_backend_name=hippo']
      )}
    end

    context 'block device backend with additional configuration' do
      before do
        params.merge!( :extra_options => {'hippo/param1' => { 'value' => 'value1' }} )
      end

      it { is_expected.to contain_cinder_config('hippo/param1').with_value('value1') }
    end

    context 'with deprecated iscsi_ip_address' do
      before do
        params.merge!({
          :target_ip_address => :undef,
          :iscsi_ip_address  => '127.0.0.42',
        })
      end

      it { is_expected.to contain_cinder_config('hippo/target_ip_address').with_value('127.0.0.42') }
    end

    context 'with no target_ip_address or iscsi_ip_address' do
      before do
        params.delete(:target_ip_address)
      end

      it { is_expected.to raise_error(Puppet::Error, /A target_ip_address or iscsi_ip_address must be specified./) }
    end
  end

  shared_examples 'check needed daemons' do
    context 'tgtadm helper' do
      it {
        is_expected.to contain_package('tgt').with_ensure('present')
        is_expected.to contain_service('tgtd').with_ensure('running')
      }
    end

    context 'lioadm helper' do
     before do
       params.merge!( :target_helper => 'lioadm' )
     end

     it {
       is_expected.to contain_package('targetcli').with_ensure('present')
       is_expected.to contain_service('target').with_ensure('running')
     }
    end

    context 'wrong helper' do
      before do
        params.merge!( :target_helper => 'fake' )
      end

      it { is_expected.to raise_error(Puppet::Error, /Unsupported target helper: fake/) }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder block device'
      it_behaves_like 'check needed daemons'
    end
  end
end
