require 'spec_helper'

describe 'cinder::wsgi::apache' do

  shared_examples_for 'apache serving cinder with mod_wsgi' do
    it { is_expected.to contain_service('httpd').with_name(platform_params[:httpd_service_name]) }
    it { is_expected.to contain_class('cinder::params') }
    it { is_expected.to contain_class('apache') }
    it { is_expected.to contain_class('apache::mod::wsgi') }

    describe 'with default parameters' do

      it { is_expected.to contain_file("#{platform_params[:wsgi_script_path]}").with(
        'ensure'  => 'directory',
        'owner'   => 'cinder',
        'group'   => 'cinder',
        'require' => 'Package[httpd]'
      )}


      it { is_expected.to contain_file('cinder_wsgi').with(
        'ensure'  => 'file',
        'path'    => "#{platform_params[:wsgi_script_path]}/cinder-api",
        'source'  => platform_params[:wsgi_script_source],
        'owner'   => 'cinder',
        'group'   => 'cinder',
        'mode'    => '0644'
      )}
      it { is_expected.to contain_file('cinder_wsgi').that_requires("File[#{platform_params[:wsgi_script_path]}]") }

      it { is_expected.to contain_apache__vhost('cinder_wsgi').with(
        'servername'                  => 'some.host.tld',
        'ip'                          => nil,
        'port'                        => '8776',
        'docroot'                     => "#{platform_params[:wsgi_script_path]}",
        'docroot_owner'               => 'cinder',
        'docroot_group'               => 'cinder',
        'ssl'                         => 'true',
        'wsgi_daemon_process'         => 'cinder-api',
        'wsgi_process_group'          => 'cinder-api',
        'wsgi_script_aliases'         => { '/' => "#{platform_params[:wsgi_script_path]}/cinder-api" },
        'require'                     => 'File[cinder_wsgi]'
      )}
      it { is_expected.to contain_concat("#{platform_params[:httpd_ports_file]}") }
    end

    describe 'when overriding parameters using different ports' do
      let :params do
        {
          :servername  => 'dummy.host',
          :bind_host   => '10.42.51.1',
          :port        => 12345,
          :ssl         => false,
          :workers     => 37,
        }
      end

      it { is_expected.to contain_apache__vhost('cinder_wsgi').with(
        'servername'                  => 'dummy.host',
        'ip'                          => '10.42.51.1',
        'port'                        => '12345',
        'docroot'                     => "#{platform_params[:wsgi_script_path]}",
        'docroot_owner'               => 'cinder',
        'docroot_group'               => 'cinder',
        'ssl'                         => 'false',
        'wsgi_daemon_process'         => 'cinder-api',
        'wsgi_process_group'          => 'cinder-api',
        'wsgi_script_aliases'         => { '/' => "#{platform_params[:wsgi_script_path]}/cinder-api" },
        'require'                     => 'File[cinder_wsgi]'
      )}

      it { is_expected.to contain_concat("#{platform_params[:httpd_ports_file]}") }
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :processorcount => 42,
          :concat_basedir => '/var/lib/puppet/concat',
          :fqdn           => 'some.host.tld',
        }))
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          {
            :httpd_service_name => 'apache2',
            :httpd_ports_file   => '/etc/apache2/ports.conf',
            :wsgi_script_path   => '/usr/lib/cgi-bin/cinder',
            :wsgi_script_source => '/usr/bin/cinder-wsgi'
          }
        when 'RedHat'
          {
            :httpd_service_name => 'httpd',
            :httpd_ports_file   => '/etc/httpd/conf/ports.conf',
            :wsgi_script_path   => '/var/www/cgi-bin/cinder',
            :wsgi_script_source => '/usr/bin/cinder-wsgi'
          }
        end
      end

      it_behaves_like 'apache serving cinder with mod_wsgi'
    end
  end
end
