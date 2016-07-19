require 'spec_helper'

describe 'cinder::backend::rbd' do

  let(:title) {'rbd-ssd'}

  let :facts do
    OSDefaults.get_facts({})
  end

  let :req_params do
    {
      :volume_backend_name              => 'rbd-ssd',
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
    @default_facts.merge({:osfamily => 'Debian'})
  end

  describe 'rbd backend volume driver' do
    it 'configure rbd volume driver' do
      is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/volume_backend_name").with_value(req_params[:volume_backend_name])
      is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/volume_driver").with_value('cinder.volume.drivers.rbd.RBDDriver')
      is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_ceph_conf").with_value(req_params[:rbd_ceph_conf])
      is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_flatten_volume_from_snapshot").with_value(req_params[:rbd_flatten_volume_from_snapshot])
      is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/volume_tmp_dir").with_value(req_params[:volume_tmp_dir])
      is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_max_clone_depth").with_value(req_params[:rbd_max_clone_depth])
      is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_pool").with_value(req_params[:rbd_pool])
      is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_user").with_value(req_params[:rbd_user])
      is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_secret_uuid").with_value(req_params[:rbd_secret_uuid])
      is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/backend_host").with_value('rbd:'"#{req_params[:rbd_pool]}")
      is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rados_connect_timeout").with_value(req_params[:rados_connect_timeout])
      is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rados_connection_interval").with_value(req_params[:rados_connection_interval])
      is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rados_connection_retries").with_value(req_params[:rados_connection_retries])
      is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_store_chunk_size").with_value(req_params[:rbd_store_chunk_size])
      is_expected.to contain_file('/etc/init/cinder-volume.override').with(:ensure => 'present')
      is_expected.to contain_file_line('set initscript env rbd-ssd').with(
        :line    => /env CEPH_ARGS=\"--id test\"/,
        :path    => '/etc/init/cinder-volume.override',
        :notify  => 'Anchor[cinder::service::begin]')
    end

    context 'with another RBD backend' do
      let :pre_condition do
        "cinder::backend::rbd { 'ceph2':
           rbd_pool => 'volumes2',
           rbd_user => 'test2'
         }"
      end
      it { is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/volume_driver").with_value('cinder.volume.drivers.rbd.RBDDriver') }
      it { is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_pool").with_value(req_params[:rbd_pool]) }
      it { is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_user").with_value(req_params[:rbd_user]) }
      it { is_expected.to contain_cinder_config("ceph2/volume_driver").with_value('cinder.volume.drivers.rbd.RBDDriver') }
      it { is_expected.to contain_cinder_config("ceph2/rbd_pool").with_value('volumes2') }
      it { is_expected.to contain_cinder_config("ceph2/rbd_user").with_value('test2') }
    end

    context 'rbd backend with additional configuration' do
      before do
        params.merge!({:extra_options => {'rbd-ssd/param1' => { 'value' => 'value1' }}})
      end

      it 'configure rbd backend with additional configuration' do
        is_expected.to contain_cinder_config('rbd-ssd/param1').with({
          :value => 'value1'
        })
      end
    end

    context 'override backend_host parameter' do
      before do
        params.merge!({:backend_host => 'test_host.fqdn.com' })
      end

      it 'configure rbd backend with specific hostname' do
        is_expected.to contain_cinder_config('rbd-ssd/backend_host').with({
          :value => 'test_host.fqdn.com',
        })
      end
    end

    context 'rbd backend with cinder type' do
      before do
        params.merge!({:manage_volume_type => true})
      end
      it 'should create type with properties' do
        should contain_cinder_type('rbd-ssd').with(:ensure => :present, :properties => ['volume_backend_name=rbd-ssd'])
      end
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
      is_expected.to contain_file_line('set initscript env rbd-ssd').with(
        :line    => /export CEPH_ARGS=\"--id test\"/,
        :path    => '/etc/sysconfig/openstack-cinder-volume',
        :notify  => 'Anchor[cinder::service::begin]')
    end
  end

end
