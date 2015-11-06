require 'spec_helper'

describe 'cinder::volume::quobyte' do

  shared_examples_for 'quobyte volume driver' do
    let :params do
      {
        :quobyte_volume_url      => 'quobyte://quobyte.cluster.example.com/volume-name',
        :quobyte_qcow2_volumes   => false,
        :quobyte_sparsed_volumes => true,
      }
    end

    it 'configures quobyte volume driver' do
      is_expected.to contain_cinder_config('DEFAULT/volume_driver').with_value(
        'cinder.volume.drivers.quobyte.QuobyteDriver')
      is_expected.to contain_cinder_config('DEFAULT/quobyte_volume_url').with_value(
        'quobyte://quobyte.cluster.example.com/volume-name')
      is_expected.to contain_cinder_config('DEFAULT/quobyte_qcow2_volumes').with_value(
        false)
      is_expected.to contain_cinder_config('DEFAULT/quobyte_sparsed_volumes').with_value(
        true)
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({:processorcount => 8}))
      end

      it_configures 'quobyte volume driver'
    end
  end

end
