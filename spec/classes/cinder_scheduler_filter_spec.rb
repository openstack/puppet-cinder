require 'spec_helper'

describe 'cinder::scheduler::filter' do
  let :default_params do
    {
      :scheduler_default_filters            => '<SERVICE DEFAULT>',
      :capacity_weight_multiplier           => '<SERVICE DEFAULT>',
      :allocated_capacity_weight_multiplier => '<SERVICE DEFAULT>',
      :volume_number_multiplier             => '<SERVICE DEFAULT>',
    }
  end

  let :params do
    {}
  end

  shared_examples 'cinder scheduler filter' do

    let :p do
      default_params.merge(params)
    end

    it 'contains default values' do
      is_expected.to contain_cinder_config('DEFAULT/scheduler_default_filters').with_value(p[:scheduler_default_filters])
      is_expected.to contain_cinder_config('DEFAULT/capacity_weight_multiplier').with_value(p[:capacity_weight_multiplier])
      is_expected.to contain_cinder_config('DEFAULT/allocated_capacity_weight_multiplier').with_value(p[:allocated_capacity_weight_multiplier])
      is_expected.to contain_cinder_config('DEFAULT/volume_number_multiplier').with_value(p[:volume_number_multiplier])
    end

    context 'configure parameters' do
      before :each do
        params.merge!({
          :capacity_weight_multiplier           => 1.0,
          :allocated_capacity_weight_multiplier => -1.0,
          :volume_number_multiplier             => -1.0,
        })
      end

      it 'contains overridden values' do
        is_expected.to contain_cinder_config('DEFAULT/capacity_weight_multiplier').with_value(p[:capacity_weight_multiplier])
        is_expected.to contain_cinder_config('DEFAULT/allocated_capacity_weight_multiplier').with_value(p[:allocated_capacity_weight_multiplier])
        is_expected.to contain_cinder_config('DEFAULT/volume_number_multiplier').with_value(p[:volume_number_multiplier])
      end
    end

    context 'configure filters with array' do
      before :each do
        params.merge!({
          :scheduler_default_filters => ['AvailabilityZoneFilter', 'CapacityFilter', 'CapabilitiesFilter']
        })
      end

      it 'contains overridden values' do
        is_expected.to contain_cinder_config('DEFAULT/scheduler_default_filters').with_value(p[:scheduler_default_filters].join(','))
      end
    end

    context 'configure filters with string' do
      before :each do
        params.merge!({
          :scheduler_default_filters => 'AvailabilityZoneFilter,CapacityFilter,CapabilitiesFilter'
        })
      end

      it 'contains overridden values' do
        is_expected.to contain_cinder_config('DEFAULT/scheduler_default_filters').with_value(p[:scheduler_default_filters])
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

      it_behaves_like 'cinder scheduler filter'
    end
  end
end
