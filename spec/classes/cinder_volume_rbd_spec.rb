require 'spec_helper'

describe 'cinder::volume::rbd' do

  let :req_params do
    {
      :rbd_pool                         => 'volumes',
      :rbd_user                         => 'test',
      :rbd_secret_uuid                  => '<SERVICE DEFAULT>',
      :rbd_ceph_conf                    => '/foo/boo/zoo/ceph.conf',
      :rbd_flatten_volume_from_snapshot => true,
      :volume_tmp_dir                   => '<SERVICE DEFAULT>',
      :rbd_max_clone_depth              => '0',
      :rados_connect_timeout            => '<SERVICE DEFAULT>',
      :rados_connection_interval        => '<SERVICE DEFAULT>',
      :rados_connection_retries         => '<SERVICE DEFAULT>',
      :rbd_store_chunk_size             => '<SERVICE DEFAULT>'
    }
  end

  it { is_expected.to contain_class('cinder::params') }

  let :params do
    req_params
  end

  let :facts do
    OSDefaults.get_facts({:osfamily => 'Debian'})
  end

  describe 'rbd volume driver' do
    it 'configure rbd volume driver' do
      is_expected.to contain_cinder_config('DEFAULT/volume_driver').with_value('cinder.volume.drivers.rbd.RBDDriver')

      is_expected.to contain_cinder_config('DEFAULT/rbd_ceph_conf').with_value(req_params[:rbd_ceph_conf])
      is_expected.to contain_cinder_config('DEFAULT/rbd_flatten_volume_from_snapshot').with_value(req_params[:rbd_flatten_volume_from_snapshot])
      is_expected.to contain_cinder_config('DEFAULT/volume_tmp_dir').with_value(req_params[:volume_tmp_dir])
      is_expected.to contain_cinder_config('DEFAULT/rbd_max_clone_depth').with_value(req_params[:rbd_max_clone_depth])
      is_expected.to contain_cinder_config('DEFAULT/rbd_pool').with_value(req_params[:rbd_pool])
      is_expected.to contain_cinder_config('DEFAULT/rbd_user').with_value(req_params[:rbd_user])
      is_expected.to contain_cinder_config('DEFAULT/rbd_secret_uuid').with_value(req_params[:rbd_secret_uuid])
      is_expected.to contain_cinder_config('DEFAULT/rados_connect_timeout').with_value(req_params[:rados_connect_timeout])
      is_expected.to contain_cinder_config('DEFAULT/rados_connection_interval').with_value(req_params[:rados_connection_interval])
      is_expected.to contain_cinder_config('DEFAULT/rados_connection_retries').with_value(req_params[:rados_connection_retries])
      is_expected.to contain_cinder_config('DEFAULT/rbd_store_chunk_size').with_value(req_params[:rbd_store_chunk_size])
      is_expected.to contain_file('/etc/init/cinder-volume.override').with(:ensure => 'present')
      is_expected.to contain_file_line('set initscript env DEFAULT').with(
        :line    => /env CEPH_ARGS=\"--id test\"/,
        :path    => '/etc/init/cinder-volume.override',
        :notify  => 'Anchor[cinder::service::begin]')
    end

  end

  describe 'rbd volume driver with additional configuration' do
    before :each do
      params.merge!({:extra_options => {'rbd_backend/param1' => {'value' => 'value1'}}})
    end
    it 'configure rbd volume with additional configuration' do
      is_expected.to contain_cinder__backend__rbd('DEFAULT').with({
        :extra_options => {'rbd_backend/param1' => {'value' => 'value1'}}
      })
    end
  end

  describe 'with RedHat' do
    let :facts do
        @default_facts.merge({ :osfamily => 'RedHat' })
    end

    let :params do
      req_params
    end

    it 'should ensure that the cinder-volume sysconfig file is present' do
      is_expected.to contain_file('/etc/sysconfig/openstack-cinder-volume').with(
        :ensure => 'present'
      )
    end

    it 'should configure RedHat init override' do
      is_expected.to contain_file_line('set initscript env DEFAULT').with(
        :line    => /export CEPH_ARGS=\"--id test\"/,
        :path    => '/etc/sysconfig/openstack-cinder-volume',
        :notify  => 'Anchor[cinder::service::begin]')
    end
  end

end

