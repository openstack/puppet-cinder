require 'spec_helper'

describe 'cinder::client' do

  let :params do
    {}
  end

  let :default_params do
    { :package_ensure   => 'present' }
  end

  shared_examples_for 'cinder client' do
    let :p do
      default_params.merge(params)
    end

    it { is_expected.to contain_class('cinder::params') }

    it 'installs cinder client package' do
      is_expected.to contain_package('python-cinderclient').with(
        :name   => 'python-cinderclient',
        :ensure => p[:package_ensure],
        :tag    => ['openstack', 'cinder-support-package'],
      )
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({:processorcount => 8}))
      end

      it_configures 'cinder client'
    end
  end
end
