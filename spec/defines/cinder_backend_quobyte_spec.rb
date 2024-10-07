require 'spec_helper'

describe 'cinder::backend::quobyte' do
  shared_examples 'cinder::backend::quobyte' do
    let(:title) {'myquobyte'}

    let :params do
      {
        :quobyte_volume_url        => 'quobyte://quobyte.cluster.example.com/volume-name',
        :quobyte_qcow2_volumes     => false,
        :quobyte_sparsed_volumes   => true,
        :backend_availability_zone => 'my_zone',
      }
    end

    it { is_expected.to contain_cinder_config('myquobyte/volume_driver').with(
      :value => 'cinder.volume.drivers.quobyte.QuobyteDriver'
    )}

    it { is_expected.to contain_cinder_config('myquobyte/quobyte_volume_url').with(
      :value => 'quobyte://quobyte.cluster.example.com/volume-name'
    )}

    it {
      is_expected.to contain_cinder_config('myquobyte/quobyte_qcow2_volumes').with_value(false)
      is_expected.to contain_cinder_config('myquobyte/quobyte_sparsed_volumes').with_value(true)
      is_expected.to contain_cinder_config('myquobyte/backend_availability_zone').with_value('my_zone')
      is_expected.to contain_cinder_config('myquobyte/image_volume_cache_enabled').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('myquobyte/image_volume_cache_max_size_gb').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_cinder_config('myquobyte/image_volume_cache_max_count').with_value('<SERVICE DEFAULT>')
    }

    context 'quobyte backend with cinder type' do
      before do
        params.merge!( :manage_volume_type => true )
      end

      it { is_expected.to contain_cinder_type('myquobyte').with(
        :ensure     => 'present',
        :properties => {'volume_backend_name' => 'myquobyte'}
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder::backend::quobyte'
    end
  end
end
