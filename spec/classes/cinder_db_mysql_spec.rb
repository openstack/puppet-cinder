require 'spec_helper'

describe 'cinder::db::mysql' do

  let :req_params do
    {:password => 'pw',
     }
  end

  let :facts do
    {:osfamily => 'Debian'}
  end

  let :pre_condition do
    'include mysql::server'
  end

  describe 'with only required params' do
    let :params do
      req_params
    end
    it { is_expected.to contain_openstacklib__db__mysql('cinder').with(
      :user          => 'cinder',
      :password_hash => '*D821809F681A40A6E379B50D0463EFAE20BDD122',
      :host          => '127.0.0.1',
      :charset       => 'utf8',
      :collate       => 'utf8_general_ci',
     ) }
  end

  describe "overriding allowed_hosts param to array" do
    let :params do
      {
        :password       => 'cinderpass',
        :allowed_hosts  => ['127.0.0.1','%']
      }
    end

    it { is_expected.to contain_openstacklib__db__mysql('cinder').with(
      :user          => 'cinder',
      :password_hash => '*1C8A189441ED992638DD234B6711CD5064DA8C6E',
      :host          => '127.0.0.1',
      :charset       => 'utf8',
      :collate       => 'utf8_general_ci',
      :allowed_hosts => ['127.0.0.1', '%']
    ) }

  end

  describe "overriding allowed_hosts param to string" do
    let :params do
      {
        :password       => 'cinderpass2',
        :allowed_hosts  => '192.168.1.1'
      }
    end

    it { is_expected.to contain_openstacklib__db__mysql('cinder').with(
      :user          => 'cinder',
      :password_hash => '*0E9E710049E74D36D29D615DFC55F3FFD45413BC',
      :host          => '127.0.0.1',
      :charset       => 'utf8',
      :collate       => 'utf8_general_ci',
      :allowed_hosts => '192.168.1.1',
    ) }

  end

  describe "overriding allowed_hosts param equals to host param " do
    let :params do
      {
        :password       => 'cinderpass2',
        :allowed_hosts  => '127.0.0.1'
      }
    end

    it { is_expected.to contain_openstacklib__db__mysql('cinder').with(
      :user          => 'cinder',
      :password_hash => '*0E9E710049E74D36D29D615DFC55F3FFD45413BC',
      :host          => '127.0.0.1',
      :charset       => 'utf8',
      :collate       => 'utf8_general_ci',
      :allowed_hosts => '127.0.0.1',
    ) }

  end

end
