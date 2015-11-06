require 'spec_helper'

describe 'cinder::scheduler::filter' do

  let :default_params do
    { :scheduler_default_filters => '<SERVICE DEFAULT>' }
  end

  let :params do
    {}
  end

  shared_examples_for 'cinder scheduler filter' do

    let :p do
      default_params.merge(params)
    end

    it 'contains default values' do
      is_expected.to contain_cinder_config('DEFAULT/scheduler_default_filters').with_ensure('absent')
    end

    context 'configure filters with array' do
      before :each do
        params.merge!({
          :scheduler_default_filters => ['AvailabilityZoneFilter', 'CapacityFilter', 'CapabilitiesFilter']
        })
      end

      it 'contains overrided values' do
        is_expected.to contain_cinder_config('DEFAULT/scheduler_default_filters').with_value(p[:scheduler_default_filters].join(','))
      end
    end

    context 'configure filters with string' do
      before :each do
        params.merge!({
          :scheduler_default_filters => 'AvailabilityZoneFilter,CapacityFilter,CapabilitiesFilter'
        })
      end

      it 'contains overrided values' do
        is_expected.to contain_cinder_config('DEFAULT/scheduler_default_filters').with_value(p[:scheduler_default_filters])
      end
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({:processorcount => 8}))
      end

      it_configures 'cinder scheduler filter'
    end
  end

end
