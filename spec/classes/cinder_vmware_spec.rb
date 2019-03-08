require 'spec_helper'

describe 'cinder::vmware' do
  shared_examples 'cinder::vmware' do
    context 'with defaults' do
      it { is_expected.to contain_cinder_type('vmware-thin').with(
        :ensure     => :present,
        :properties => ['vmware:vmdk_type=thin']
      )}

      it { is_expected.to contain_cinder_type('vmware-thick').with(
        :ensure     => :present,
        :properties => ['vmware:vmdk_type=thick']
      )}

      it { is_expected.to contain_cinder_type('vmware-eagerZeroedThick').with(
        :ensure     => :present,
        :properties => ['vmware:vmdk_type=eagerZeroedThick']
      )}

      it { is_expected.to contain_cinder_type('vmware-full').with(
        :ensure     => :present,
        :properties => ['vmware:clone_type=full']
      )}

      it { is_expected.to contain_cinder_type('vmware-linked').with(
        :ensure     => :present,
        :properties => ['vmware:clone_type=linked']
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'cinder::vmware'
    end
  end
end
