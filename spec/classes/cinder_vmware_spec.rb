require 'spec_helper'

describe 'cinder::vmware' do

  describe 'with defaults' do
    it 'should create vmware special types' do
      is_expected.to contain_cinder_type('vmware-thin').with(
                 :ensure     => :present,
                 :properties => ['vmware:vmdk_type=thin'])

      is_expected.to contain_cinder_type('vmware-thick').with(
                 :ensure     => :present,
                 :properties => ['vmware:vmdk_type=thick'])

      is_expected.to contain_cinder_type('vmware-eagerZeroedThick').with(
                 :ensure     => :present,
                 :properties => ['vmware:vmdk_type=eagerZeroedThick'])

      is_expected.to contain_cinder_type('vmware-full').with(
                 :ensure     => :present,
                 :properties => ['vmware:clone_type=full'])

      is_expected.to contain_cinder_type('vmware-linked').with(
                 :ensure     => :present,
                 :properties => ['vmware:clone_type=linked'])
    end
  end
end
