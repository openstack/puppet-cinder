require 'spec_helper'

describe 'cinder::scheduler' do
  shared_examples 'cinder::scheduler on Debian' do
    context 'with default parameters' do
      it { is_expected.to contain_class('cinder::params') }
      it { is_expected.to contain_cinder_config('DEFAULT/scheduler_driver').with_value('<SERVICE DEFAULT>') }

      it { is_expected.to contain_package('cinder-scheduler').with(
        :name   => 'cinder-scheduler',
        :ensure => 'present',
        :tag    => ['openstack', 'cinder-package'],
      )}

      it { is_expected.to contain_service('cinder-scheduler').with(
        :name      => 'cinder-scheduler',
        :enable    => true,
        :ensure    => 'running',
        :hasstatus => true,
        :tag       => 'cinder-service',
      )}
    end

    context 'with parameters' do
      let :params do
        {
          :scheduler_driver => 'cinder.scheduler.filter_scheduler.FilterScheduler',
          :package_ensure   => 'present'
        }
      end

      it { is_expected.to contain_cinder_config('DEFAULT/scheduler_driver').with_value('cinder.scheduler.filter_scheduler.FilterScheduler') }
      it { is_expected.to contain_package('cinder-scheduler').with_ensure('present') }
    end

    context 'with manage_service false' do
      let :params do
        {
          :manage_service => false
        }
      end

      it { is_expected.to_not contain_service('cinder-scheduler') }
    end
  end

  shared_examples 'cinder::scheduler on RedHat' do
    context 'with default parameters' do
      it { is_expected.to contain_class('cinder::params') }

      it { is_expected.to contain_service('cinder-scheduler').with(
        :name   => 'openstack-cinder-scheduler',
        :enable => true,
        :ensure => 'running',
      )}
    end

    context 'with parameters' do
      let :params do
        {
          :scheduler_driver => 'cinder.scheduler.filter_scheduler.FilterScheduler'
        }
      end

      it { is_expected.to contain_cinder_config('DEFAULT/scheduler_driver').with_value('cinder.scheduler.filter_scheduler.FilterScheduler') }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like "cinder::scheduler on #{facts[:os]['family']}"
    end
  end
end
