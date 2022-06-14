require 'spec_helper'

describe 'cinder::backend::defaults' do

  shared_examples 'cinder backend defaults' do

    context 'configure cinder with default backend_defaults parameters' do
      it { is_expected.to contain_cinder_config('backend_defaults/use_multipath_for_image_xfer').with_value('<SERVICE DEFAULT>') }
    end

    context 'configure cinder with user defined backend_defaults parameters' do
      let(:params) do
        { :use_multipath_for_image_xfer => true, }
      end
      it { is_expected.to contain_cinder_config('backend_defaults/use_multipath_for_image_xfer').with_value(true) }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts)
      end

      it_behaves_like 'cinder backend defaults'
    end
  end
end
