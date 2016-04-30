require 'spec_helper'

describe 'cinder::db::postgresql' do

  shared_examples_for 'cinder::db::postgresql' do
    let :req_params do
      { :password => 'pw' }
    end

    let :pre_condition do
      'include postgresql::server'
    end

    context 'with only required parameters' do
      let :params do
        req_params
      end

      it { is_expected.to contain_postgresql__server__db('cinder').with(
        :user     => 'cinder',
        :password => 'md506736c3030793e09882cc536063d433f'
      )}
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :processorcount => 8,
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end

      it_configures 'cinder::db::postgresql'
    end
  end

end
