require 'spec_helper'

describe 'cinder::backend::rbd' do
  let(:title) {'rbd-ssd'}

  let :req_params do
    {
      :volume_backend_name => 'rbd-ssd',
      :rbd_pool            => 'volumes',
      :rbd_user            => 'test',
    }
  end

  let :params do
    req_params
  end

  shared_examples 'cinder::backend::rbd' do
    it { is_expected.to contain_class('cinder::params') }

    context 'rbd backend volume driver' do
      it {
        is_expected.to contain_package('ceph-common').with_ensure('installed')
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/volume_backend_name").with_value(req_params[:volume_backend_name])
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/volume_driver").with_value('cinder.volume.drivers.rbd.RBDDriver')
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_ceph_conf").with_value('/etc/ceph/ceph.conf')
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_flatten_volume_from_snapshot").with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_max_clone_depth").with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_pool").with_value(req_params[:rbd_pool])
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_user").with_value(req_params[:rbd_user])
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_secret_uuid").with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/backend_host").with_value('rbd:'"#{req_params[:rbd_pool]}")
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rados_connect_timeout").with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rados_connection_interval").with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rados_connection_retries").with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_store_chunk_size").with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/report_dynamic_total_capacity").with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_exclusive_cinder_pool").with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/report_discard_supported").with_value(true)
      }

      context 'with parameters' do
        let :params do
          req_params.merge!({
            :rbd_ceph_conf                    => '/opt/ceph.conf',
            :rbd_flatten_volume_from_snapshot => true,
            :rbd_secret_uuid                  => 'b129523a-61a5-4653-86d1-2b055f970801',
            :rbd_max_clone_depth              => 5,
            :rados_connect_timeout            => 10,
            :rados_connection_interval        => 5,
            :rados_connection_retries         => 3,
            :rbd_store_chunk_size             => 4,
            :report_dynamic_total_capacity    => true,
            :rbd_exclusive_cinder_pool        => false,
          })
        end

        it {
          is_expected.to contain_package('ceph-common').with_ensure('installed')
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/volume_backend_name").with_value(req_params[:volume_backend_name])
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/volume_driver").with_value('cinder.volume.drivers.rbd.RBDDriver')
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_ceph_conf").with_value(params[:rbd_ceph_conf])
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_flatten_volume_from_snapshot").with_value(params[:rbd_flatten_volume_from_snapshot])
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_max_clone_depth").with_value(params[:rbd_max_clone_depth])
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_pool").with_value(req_params[:rbd_pool])
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_user").with_value(req_params[:rbd_user])
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_secret_uuid").with_value(params[:rbd_secret_uuid])
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/backend_host").with_value('rbd:'"#{req_params[:rbd_pool]}")
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rados_connect_timeout").with_value(params[:rados_connect_timeout])
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rados_connection_interval").with_value(params[:rados_connection_interval])
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rados_connection_retries").with_value(params[:rados_connection_retries])
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_store_chunk_size").with_value(params[:rbd_store_chunk_size])
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/report_dynamic_total_capacity").with_value(params[:report_dynamic_total_capacity])
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_exclusive_cinder_pool").with_value(params[:rbd_exclusive_cinder_pool])
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/report_discard_supported").with_value(true)
        }
      end

      context 'with another RBD backend' do
        let :pre_condition do
          "cinder::backend::rbd { 'ceph2':
             rbd_ceph_conf => '/foo/boo/zoo/ceph2.conf',
             rbd_pool => 'volumes2',
             rbd_user => 'test2'
           }"
        end

        it { is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/volume_driver").with_value('cinder.volume.drivers.rbd.RBDDriver') }
        it { is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_pool").with_value(req_params[:rbd_pool]) }
        it { is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_user").with_value(req_params[:rbd_user]) }
        it { is_expected.to contain_cinder_config("ceph2/volume_driver").with_value('cinder.volume.drivers.rbd.RBDDriver') }
        it { is_expected.to contain_cinder_config("ceph2/rbd_cluster_name").with_value('ceph2') }
        it { is_expected.to contain_cinder_config("ceph2/rbd_pool").with_value('volumes2') }
        it { is_expected.to contain_cinder_config("ceph2/rbd_user").with_value('test2') }
        it { is_expected.to contain_cinder_config("ceph2/report_discard_supported").with_value(true) }
      end

      context 'rbd backend with additional configuration' do
        before do
          params.merge!( :extra_options => {'rbd-ssd/param1' => { 'value' => 'value1' }} )
        end

        it { is_expected.to contain_cinder_config('rbd-ssd/param1').with_value('value1') }
      end

      context 'override backend_host and backend_availability_zone parameters' do
        before do
          params.merge!({
            :backend_host              => 'test_host.fqdn.com',
            :backend_availability_zone => 'my_zone',
          })
        end

        it { is_expected.to contain_cinder_config('rbd-ssd/backend_host').with_value('test_host.fqdn.com') }
        it { is_expected.to contain_cinder_config('rbd-ssd/backend_availability_zone').with_value('my_zone') }
      end

      context 'rbd backend with cinder type' do
        before do
          params.merge!( :manage_volume_type => true )
        end

        it { is_expected.to contain_cinder_type('rbd-ssd').with(
          :ensure     => 'present',
          :properties => ['volume_backend_name=rbd-ssd']
        )}
      end
    end
  end

  shared_examples 'cinder::backend::rbd on Debian' do
    it { is_expected.to contain_file('/etc/default/cinder-volume').with(
      :ensure => 'present'
    )}

    it { is_expected.to contain_file_line('set initscript env rbd-ssd').with(
      :line   => /CEPH_ARGS=\"--id test\"/,
      :path   => '/etc/default/cinder-volume',
      :notify => 'Anchor[cinder::service::begin]'
    )}
  end

  shared_examples 'cinder::backend::rbd on RedHat' do
    it { is_expected.to contain_file('/etc/sysconfig/openstack-cinder-volume').with(
      :ensure => 'present'
    )}

    it { is_expected.to contain_file_line('set initscript env rbd-ssd').with(
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
