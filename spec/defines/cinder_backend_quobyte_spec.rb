require 'spec_helper'

describe 'cinder::backend::quobyte' do

  shared_examples_for 'quobyte volume driver' do
    let(:title) {'myquobyte'}

    let :params do
      {
	:quobyte_volume_url      => 'quobyte://quobyte.cluster.example.com/volume-name',
        :quobyte_qcow2_volumes   => false,
        :quobyte_sparsed_volumes => true,
      }
    end

    it 'configures quobyte volume driver' do
      is_expected.to contain_cinder_config('myquobyte/volume_driver').with_value(
        'cinder.volume.drivers.quobyte.QuobyteDriver')
      is_expected.to contain_cinder_config('myquobyte/quobyte_volume_url').with_value(
        'quobyte://quobyte.cluster.example.com/volume-name')
      is_expected.to contain_cinder_config('myquobyte/quobyte_qcow2_volumes').with_value(
        false)
      is_expected.to contain_cinder_config('myquobyte/quobyte_sparsed_volumes').with_value(
        true)
    end

  end

  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    it_configures 'quobyte volume driver'
  end

  context 'on RedHat platforms' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    it_configures 'quobyte volume driver'
  end

end
