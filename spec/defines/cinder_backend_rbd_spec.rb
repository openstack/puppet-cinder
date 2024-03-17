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
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/backend_availability_zone").with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/reserved_percentage").with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/max_over_subscription_ratio").with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rados_connect_timeout").with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rados_connection_interval").with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rados_connection_retries").with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_store_chunk_size").with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/report_dynamic_total_capacity").with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_exclusive_cinder_pool").with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/enable_deferred_deletion").with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/deferred_deletion_delay").with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/deferred_deletion_purge_interval").with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_concurrent_flatten_operations").with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/report_discard_supported").with_value(true)
      }

      context 'with parameters' do
        let :params do
          req_params.merge!({
            :backend_host                      => 'test_host.fqdn.com',
            :backend_availability_zone         => 'my_zone',
            :reserved_percentage               => 10,
            :max_over_subscription_ratio       => 1.5,
            :rbd_ceph_conf                     => '/opt/ceph.conf',
            :rbd_flatten_volume_from_snapshot  => true,
            :rbd_secret_uuid                   => 'b129523a-61a5-4653-86d1-2b055f970801',
            :rbd_max_clone_depth               => 5,
            :rados_connect_timeout             => 10,
            :rados_connection_interval         => 5,
            :rados_connection_retries          => 3,
            :rbd_store_chunk_size              => 4,
            :report_dynamic_total_capacity     => true,
            :rbd_exclusive_cinder_pool         => false,
            :enable_deferred_deletion          => false,
            :deferred_deletion_delay           => 0,
            :deferred_deletion_purge_interval  => 60,
            :rbd_concurrent_flatten_operations => 3,
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
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/backend_host").with_value('test_host.fqdn.com')
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/backend_availability_zone").with_value('my_zone')
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/reserved_percentage").with_value(10)
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/max_over_subscription_ratio").with_value(1.5)
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rados_connect_timeout").with_value(params[:rados_connect_timeout])
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rados_connection_interval").with_value(params[:rados_connection_interval])
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rados_connection_retries").with_value(params[:rados_connection_retries])
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_store_chunk_size").with_value(params[:rbd_store_chunk_size])
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/report_dynamic_total_capacity").with_value(params[:report_dynamic_total_capacity])
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_exclusive_cinder_pool").with_value(params[:rbd_exclusive_cinder_pool])
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/enable_deferred_deletion").with_value(params[:enable_deferred_deletion])
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/deferred_deletion_delay").with_value(params[:deferred_deletion_delay])
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/deferred_deletion_purge_interval").with_value(params[:deferred_deletion_purge_interval])
          is_expected.to contain_cinder_config("#{req_params[:volume_backend_name]}/rbd_concurrent_flatten_operations").with_value(params[:rbd_concurrent_flatten_operations])
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

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder::backend::rbd'
    end
  end
end
