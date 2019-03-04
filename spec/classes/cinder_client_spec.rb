require 'spec_helper'

describe 'cinder::client' do
  let :params do
    {}
  end

  let :default_params do
    {
      :package_ensure => 'present'
    }
  end

  shared_examples 'cinder client' do
    let :p do
      default_params.merge(params)
    end

    it { is_expected.to contain_class('cinder::params') }

    it 'installs cinder client package' do
      is_expected.to contain_package('python-cinderclient').with(
        :name   => platform_params[:client_package_name],
        :ensure => p[:package_ensure],
        :tag    => ['openstack', 'cinder-support-package'],
      )
    end

    it { is_expected.to contain_class('openstacklib::openstackclient') }
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({:os_workers => 8}))
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          { :client_package_name => 'python3-cinderclient' }
        when 'RedHat'
          { :client_package_name => 'python-cinderclient' }
        end
      end

      it_behaves_like 'cinder client'
    end
  end
end
