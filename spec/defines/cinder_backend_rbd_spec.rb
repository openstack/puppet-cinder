require 'spec_helper'

describe 'cinder::backend::rbd' do
  let(:title) {'rbd-ssd'}

  let :req_params do
    {
      :volume_backend_name              => 'rbd-ssd',
      :rbd_pool                         => 'volumes',
      :rbd_user                         => 'test',
      :rbd_secret_uuid                  => '<SERVICE DEFAULT>',
      :rbd_ceph_conf                    => '/foo/boo/zoo/ceph.conf',
      :rbd_flatten_volume_from_snapshot => true,
      :rbd_max_clone_depth              => '0',
      :rados_connect_timeout            => '<SERVICE DEFAULT>',
      :rados_connection_interval        => '<SERVICE DEFAULT>',
      :rados_connection_retries         => '<SERVICE DEFAULT>',
      :rbd_store_chunk_size             => '<SERVICE DEFAULT>'
    }
  end

  let :params do
    req_params
  end

  shared_examples 'cinder::backend::rbd' do
    it { should contain_class('cinder::params') }

    context 'rbd backend volume driver' do
      it {
        should contain_package('ceph-common').with_ensure('present')
        should contain_cinder_config("#{req_params[:volume_backend_name]}/volume_backend_name").with_value(req_params[:volume_backend_name])
        should contain_cinder_config("#{req_params[:volume_backend_name]}/volume_driver").with_value('cinder.volume.drivers.rbd.RBDDriver')
        should contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_ceph_conf").with_value(req_params[:rbd_ceph_conf])
        should contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_flatten_volume_from_snapshot").with_value(req_params[:rbd_flatten_volume_from_snapshot])
        should contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_max_clone_depth").with_value(req_params[:rbd_max_clone_depth])
        should contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_pool").with_value(req_params[:rbd_pool])
        should contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_user").with_value(req_params[:rbd_user])
        should contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_secret_uuid").with_value(req_params[:rbd_secret_uuid])
        should contain_cinder_config("#{req_params[:volume_backend_name]}/backend_host").with_value('rbd:'"#{req_params[:rbd_pool]}")
        should contain_cinder_config("#{req_params[:volume_backend_name]}/rados_connect_timeout").with_value(req_params[:rados_connect_timeout])
        should contain_cinder_config("#{req_params[:volume_backend_name]}/rados_connection_interval").with_value(req_params[:rados_connection_interval])
        should contain_cinder_config("#{req_params[:volume_backend_name]}/rados_connection_retries").with_value(req_params[:rados_connection_retries])
        should contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_store_chunk_size").with_value(req_params[:rbd_store_chunk_size])
      }

      context 'with another RBD backend' do
        let :pre_condition do
          "cinder::backend::rbd { 'ceph2':
             rbd_ceph_conf => '/foo/boo/zoo/ceph2.conf',
             rbd_pool => 'volumes2',
             rbd_user => 'test2'
           }"
        end

        it { should contain_cinder_config("#{req_params[:volume_backend_name]}/volume_driver").with_value('cinder.volume.drivers.rbd.RBDDriver') }
        it { should contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_pool").with_value(req_params[:rbd_pool]) }
        it { should contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_user").with_value(req_params[:rbd_user]) }
        it { should contain_cinder_config("ceph2/volume_driver").with_value('cinder.volume.drivers.rbd.RBDDriver') }
        it { should contain_cinder_config("ceph2/rbd_cluster_name").with_value('ceph2') }
        it { should contain_cinder_config("ceph2/rbd_pool").with_value('volumes2') }
        it { should contain_cinder_config("ceph2/rbd_user").with_value('test2') }
      end

      context 'rbd backend with additional configuration' do
        before do
          params.merge!( :extra_options => {'rbd-ssd/param1' => { 'value' => 'value1' }} )
        end

        it { should contain_cinder_config('rbd-ssd/param1').with_value('value1') }
      end

      context 'override backend_host and backend_availability_zone parameters' do
        before do
          params.merge!({
            :backend_host              => 'test_host.fqdn.com',
            :backend_availability_zone => 'my_zone',
          })
        end

        it { should contain_cinder_config('rbd-ssd/backend_host').with_value('test_host.fqdn.com') }
        it { should contain_cinder_config('rbd-ssd/backend_availability_zone').with_value('my_zone') }
      end

      context 'rbd backend with cinder type' do
        before do
          params.merge!( :manage_volume_type => true )
        end

        it { should contain_cinder_type('rbd-ssd').with(
          :ensure     => 'present',
          :properties => ['volume_backend_name=rbd-ssd']
        )}
      end
    end
  end

  shared_examples 'cinder::backend::rbd on Debian' do
    it { should contain_file('/etc/init/cinder-volume.override').with(
      :ensure => 'present'
    )}

    it { should contain_file_line('set initscript env rbd-ssd').with(
      :line   => /env CEPH_ARGS=\"--id test\"/,
      :path   => '/etc/init/cinder-volume.override',
      :notify => 'Anchor[cinder::service::begin]'
    )}
  end

  shared_examples 'cinder::backend::rbd on RedHat' do
    it { should contain_file('/etc/sysconfig/openstack-cinder-volume').with(
      :ensure => 'present'
    )}

    it { should contain_file_line('set initscript env rbd-ssd').with(
      :line   => /export CEPH_ARGS=\"--id test\"/,
      :path   => '/etc/sysconfig/openstack-cinder-volume',
      :notify => 'Anchor[cinder::service::begin]'
    )}
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder::backend::rbd'
      it_behaves_like "cinder::backend::rbd on #{facts[:osfamily]}"
    end
  end
end
