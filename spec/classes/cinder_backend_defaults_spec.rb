require 'spec_helper'

describe 'cinder::backend::defaults' do

  shared_examples 'cinder backend defaults' do

    context 'with defaults' do
      it 'should configure cinder with default backend_defaults parameters' do
        is_expected.to contain_cinder_config('backend_defaults/use_multipath_for_image_xfer').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('backend_defaults/image_volume_cache_enabled').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('backend_defaults/image_volume_cache_max_size_gb').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cinder_config('backend_defaults/image_volume_cache_max_count').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with parameters' do
      let(:params) do
        {
          :use_multipath_for_image_xfer   => true,
          :image_volume_cache_enabled     => true,
          :image_volume_cache_max_size_gb => 100,
          :image_volume_cache_max_count   => 101,
        }
      end

      it 'should configure cinder with user defined backend_defaults parameters' do
        is_expected.to contain_cinder_config('backend_defaults/use_multipath_for_image_xfer').with_value(true)
        is_expected.to contain_cinder_config('backend_defaults/image_volume_cache_enabled').with_value(true)
        is_expected.to contain_cinder_config('backend_defaults/image_volume_cache_max_size_gb').with_value(100)
        is_expected.to contain_cinder_config('backend_defaults/image_volume_cache_max_count').with_value(101)
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

      it_behaves_like 'cinder backend defaults'
    end
  end
end
