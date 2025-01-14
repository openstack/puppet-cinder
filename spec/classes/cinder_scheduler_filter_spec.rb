require 'spec_helper'

describe 'cinder::scheduler::filter' do
  shared_examples 'cinder::scheduler::filter' do


    context 'with defaults' do
      it 'contains default values' do
        is_expected.to contain_cinder_config('DEFAULT/scheduler_default_filters').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/scheduler_default_weighers').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/scheduler_weight_handler').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/capacity_weight_multiplier').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/allocated_capacity_weight_multiplier').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('DEFAULT/volume_number_multiplier').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with parmeters' do
      let :params do
        {
          :default_filters                      => 'AvailabilityZoneFilter,CapacityFilter,CapabilitiesFilter',
          :default_weighers                     => 'CapacityWeigher,AllocatedCapacityWeigher',
          :weight_handler                       => 'cinder.scheduler.weights.OrderedHostWeightHandler',
          :capacity_weight_multiplier           => 1.0,
          :allocated_capacity_weight_multiplier => -1.0,
          :volume_number_multiplier             => -1.1,
        }
      end

      it 'contains overridden values' do
        is_expected.to contain_cinder_config('DEFAULT/scheduler_default_filters').with_value(
          'AvailabilityZoneFilter,CapacityFilter,CapabilitiesFilter'
        )
        is_expected.to contain_cinder_config('DEFAULT/scheduler_default_weighers').with_value(
          'CapacityWeigher,AllocatedCapacityWeigher'
        )
        is_expected.to contain_cinder_config('DEFAULT/scheduler_weight_handler').with_value(
          'cinder.scheduler.weights.OrderedHostWeightHandler'
        )
        is_expected.to contain_cinder_config('DEFAULT/capacity_weight_multiplier').with_value(1.0)
        is_expected.to contain_cinder_config('DEFAULT/allocated_capacity_weight_multiplier').with_value(-1.0)
        is_expected.to contain_cinder_config('DEFAULT/volume_number_multiplier').with_value(-1.1)
      end
    end

    context 'with parameters (array values)' do
      let :params do
        {
          :default_filters  => ['AvailabilityZoneFilter', 'CapacityFilter', 'CapabilitiesFilter'],
          :default_weighers => ['CapacityWeigher', 'AllocatedCapacityWeigher'],
        }
      end

      it 'contains overridden values' do
        is_expected.to contain_cinder_config('DEFAULT/scheduler_default_filters').with_value(
          'AvailabilityZoneFilter,CapacityFilter,CapabilitiesFilter'
        )
        is_expected.to contain_cinder_config('DEFAULT/scheduler_default_weighers').with_value(
          'CapacityWeigher,AllocatedCapacityWeigher'
        )
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder::scheduler::filter'
    end
  end
end
