require 'spec_helper'

describe 'cinder::scheduler' do

  describe 'on debian plateforms' do

    let :facts do
      { :osfamily => 'Debian' }
    end

    describe 'with default parameters' do

      it { should contain_class('cinder::params') }

      it { should contain_package('cinder-scheduler').with(
        :name      => 'cinder-scheduler',
        :ensure    => 'present',
        :before    => 'Service[cinder-scheduler]'
      ) }

      it { should contain_service('cinder-scheduler').with(
        :name      => 'cinder-scheduler',
        :enable    => true,
        :ensure    => 'running',
        :require   => 'Package[cinder]',
        :hasstatus => true
      ) }
    end

    describe 'with parameters' do

      let :params do
        { :scheduler_driver => 'cinder.scheduler.filter_scheduler.FilterScheduler',
          :package_ensure   => 'present'
        }
      end

      it { should contain_cinder_config('DEFAULT/scheduler_driver').with_value('cinder.scheduler.filter_scheduler.FilterScheduler') }
      it { should contain_package('cinder-scheduler').with_ensure('present') }
    end
  end


  describe 'on rhel plateforms' do

    let :facts do
      { :osfamily => 'RedHat' }
    end

    describe 'with default parameters' do

      it { should contain_class('cinder::params') }

      it { should contain_service('cinder-scheduler').with(
        :name    => 'openstack-cinder-scheduler',
        :enable  => true,
        :ensure  => 'running',
        :require => 'Package[cinder]'
      ) }
    end

    describe 'with parameters' do

      let :params do
        { :scheduler_driver => 'cinder.scheduler.filter_scheduler.FilterScheduler' }
      end

      it { should contain_cinder_config('DEFAULT/scheduler_driver').with_value('cinder.scheduler.filter_scheduler.FilterScheduler') }
    end
  end
end
