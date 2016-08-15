require 'spec_helper'

describe 'cinder::backend::gpfs' do

  let (:title) { 'gpfs' }

  let :params do
  {
      :gpfs_mount_point_base  => '/opt/gpfs/cinder/volumes',
  }
  end

  let :default_params do
  {
      :gpfs_max_clone_depth   => '<SERVICE DEFAULT>',
      :gpfs_sparse_volumes    => '<SERVICE DEFAULT>',
      :gpfs_storage_pool      => '<SERVICE DEFAULT>',
      :gpfs_images_dir        => '<SERVICE DEFAULT>',
      :gpfs_images_share_mode => '<SERVICE DEFAULT>',
      :nas_host               => '<SERVICE DEFAULT>',
      :nas_login              => '<SERVICE DEFAULT>',
      :nas_password           => '<SERVICE DEFAULT>',
      :nas_private_key        => '<SERVICE DEFAULT>',
      :nas_ssh_port           => '<SERVICE DEFAULT>',
  }
  end

  let :custom_params do
  {
      :gpfs_max_clone_depth   => 1,
      :gpfs_sparse_volumes    => false,
      :gpfs_storage_pool      => 'foo',
      :nas_host               => 'nas_host',
      :nas_login              => 'admin',
      :nas_password           => 'nas_password',
      :nas_private_key        => '/path/to/private_key',
      :nas_ssh_port           => '22',
    }
  end

  let :facts do
    OSDefaults.get_facts({})
  end

  shared_examples_for 'gpfs volume driver' do
    let :params_hash do
      default_params.merge(params)
    end

    it 'configures gpfs volume driver' do
      is_expected.to contain_cinder_config('gpfs/volume_driver').with_value(
        'cinder.volume.drivers.ibm.gpfs.GPFSDriver')
      params_hash.each_pair do |config,value|
        is_expected.to contain_cinder_config("gpfs/#{config}").with_value( value )
      end
    end
  end

  context 'with default parameters' do
    it_configures 'gpfs volume driver'
  end

  context 'with additional image parameters' do
    before do
      params.merge!({
        :gpfs_images_dir        => '/gpfs/glance/images',
        :gpfs_images_share_mode => 'copy_on_write',
      })
    end
    it_configures 'gpfs volume driver'
  end

  context 'with custom parameters' do
    before do
      params.merge(custom_params)
    end
    it_configures 'gpfs volume driver'
  end

  context 'with image share mode but without image path' do
    before do
      params.merge!({
        :gpfs_images_share_mode => 'copy_on_write',
      })
    end
    it_raises 'a Puppet::Error', /gpfs_images_share_mode only in conjunction with gpfs_images_dir/
  end

  context 'with wrong gpfs_images_share_mode' do
    before do
      params.merge!({
        :gpfs_images_share_mode => 'foo',
      })
    end
    it_raises 'a Puppet::Error', /gpfs_images_share_mode only support `copy` or `copy_on_write`/
  end

  context 'gpfs backend with cinder type' do
    before do
      params.merge!({:manage_volume_type => true})
    end
    it 'should create type with properties' do
      should contain_cinder_type('gpfs').with(:ensure => :present, :properties => ['volume_backend_name=gpfs'])
    end
  end

  context 'gpfs backend with additional configuration' do
    before do
      params.merge!({:extra_options => {'gpfs/param1' => { 'value' => 'value1' }}})
    end

    it 'configure gpfs backend with additional configuration' do
      is_expected.to contain_cinder_config('gpfs/param1').with({
        :value => 'value1'
      })
    end
  end
end
