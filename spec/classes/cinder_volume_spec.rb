require 'spec_helper'

describe 'cinder::volume' do
  let :pre_condition do
    "class { 'cinder::db':
       database_connection => 'mysql://a:b@c/d'
     }"
  end

  shared_examples 'cinder::volume' do
    it { is_expected.to contain_service('cinder-volume').with(
      :hasstatus => true,
      :tag       => 'cinder-service',
    )}

    it {
      is_expected.to contain_cinder_config('DEFAULT/cluster').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('DEFAULT/volume_clear').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('DEFAULT/volume_clear_size').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('DEFAULT/volume_clear_ionice').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('DEFAULT/migration_create_volume_timeout_secs').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('DEFAULT/volume_service_inithost_offload').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('DEFAULT/reinit_driver_count').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('DEFAULT/init_host_max_objects_retrieval').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('DEFAULT/backend_stats_polling_interval').with_value('<SERVICE DEFAULT>')
    }

    context 'with manage_service false' do
      let :params do
        {
          :manage_service => false
        }
      end

      it { is_expected.to contain_service('cinder-volume').without_ensure }
    end

    context 'with parameters overridden' do
      let :params do
        {
          :cluster                              => 'my_cluster',
          :volume_clear                         => 'none',
          :volume_clear_size                    => '10',
          :volume_clear_ionice                  => '-c3',
          :migration_create_volume_timeout_secs => 300,
          :volume_service_inithost_offload      => true,
          :reinit_driver_count                  => 3,
          :init_host_max_objects_retrieval      => 0,
          :backend_stats_polling_interval       => 60,
        }
      end

      it {
        is_expected.to contain_cinder_config('DEFAULT/cluster').with_value('my_cluster')
        is_expected.to contain_cinder_config('DEFAULT/volume_clear').with_value('none')
        is_expected.to contain_cinder_config('DEFAULT/volume_clear_size').with_value('10')
        is_expected.to contain_cinder_config('DEFAULT/volume_clear_ionice').with_value('-c3')
        is_expected.to contain_cinder_config('DEFAULT/migration_create_volume_timeout_secs').with_value(300)
        is_expected.to contain_cinder_config('DEFAULT/volume_service_inithost_offload').with_value(true)
        is_expected.to contain_cinder_config('DEFAULT/reinit_driver_count').with_value(3)
        is_expected.to contain_cinder_config('DEFAULT/init_host_max_objects_retrieval').with_value(0)
        is_expected.to contain_cinder_config('DEFAULT/backend_stats_polling_interval').with_value(60)
      }
    end
  end

  shared_examples 'cinder::volume on Debian' do
    it { is_expected.to contain_package('cinder-volume').with_ensure('present') }
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder::volume'

      if facts[:osfamily] == 'Debian'
        it_behaves_like 'cinder::volume on Debian'
      end
    end
  end
end
