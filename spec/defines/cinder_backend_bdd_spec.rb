require 'spec_helper'

describe 'cinder::backend::bdd' do

  let(:title) { 'hippo' }

  let :params do {
    :iscsi_ip_address  => '127.0.0.2',
    :available_devices => '/dev/sda',
  }
  end

  shared_examples_for 'cinder block device' do
    context 'with default parameters' do
      it 'should configure bdd driver in cinder.conf with defaults' do
        should contain_cinder_config('hippo/volume_backend_name').with_value('hippo')
        should contain_cinder_config('hippo/volume_driver').with_value('cinder.volume.drivers.block_device.BlockDeviceDriver')
        should contain_cinder_config('hippo/available_devices').with_value('/dev/sda')
        should contain_cinder_config('hippo/iscsi_helper').with_value('tgtadm')
        should contain_cinder_config('hippo/volumes_dir').with_value('/var/lib/cinder/volumes')
        should contain_cinder_config('hippo/iscsi_ip_address').with_value('127.0.0.2')
        should contain_cinder_config('hippo/volume_group').with_value('<SERVICE DEFAULT>')
        should contain_cinder_config('hippo/iscsi_protocol').with_value('<SERVICE DEFAULT>')
        should contain_cinder_config('hippo/volume_clear').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with optional parameters' do
      before :each do
        params.merge!({
          :iscsi_ip_address   => '10.20.0.2',
          :available_devices  => '/dev/sdb,/dev/sdc',
          :volumes_dir        => '/var/lib/cinder/bdd-volumes',
          :volume_clear       => 'zero',
          :volume_group       => 'cinder',
          :iscsi_helper       => 'lioadm',
          :manage_volume_type => true,
        })
      end

      it 'should configure bdd driver in cinder.conf' do
        should contain_cinder_config('hippo/available_devices').with_value('/dev/sdb,/dev/sdc')
        should contain_cinder_config('hippo/volumes_dir').with_value('/var/lib/cinder/bdd-volumes')
        should contain_cinder_config('hippo/iscsi_ip_address').with_value('10.20.0.2')
        should contain_cinder_config('hippo/iscsi_helper').with_value('lioadm')
        should contain_cinder_config('hippo/volume_group').with_value('cinder')
        should contain_cinder_config('hippo/volume_clear').with_value('zero')
      end
      it 'should create type with properties' do
        should contain_cinder_type('hippo').with(:ensure => :present, :properties => ['volume_backend_name=hippo'])
      end
    end

    context 'block device backend with additional configuration' do
      before do
        params.merge!({:extra_options => {'hippo/param1' => { 'value' => 'value1' }}})
      end

      it 'configure vmdk backend with additional configuration' do
        is_expected.to contain_cinder_config('hippo/param1').with({
          :value => 'value1'
        })
      end
    end
  end

  shared_examples_for 'check needed daemons' do
    context 'tgtadm helper' do
      it 'is expected to have tgtd daemon' do
        is_expected.to contain_package('tgt').with(:ensure => :present)
        is_expected.to contain_service('tgtd').with(:ensure => :running)
      end
    end

    context 'lioadm helper' do
     before do
       params.merge!({:iscsi_helper => 'lioadm'})
     end
     it 'is expected to have target daemon' do
       is_expected.to contain_package('targetcli').with(:ensure => :present)
       is_expected.to contain_service('target').with(:ensure => :running)
     end
    end

    context 'wrong helper' do
      before do
        params.merge!({:iscsi_helper => 'fake'})
      end
      it 'is expected to raise error' do
        is_expected.to raise_error(Puppet::Error, /Unsupported iscsi helper: fake/)
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

      it_configures 'cinder block device'
      it_configures 'check needed daemons'
    end
  end
end
