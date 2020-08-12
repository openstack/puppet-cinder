require 'spec_helper'

describe 'cinder::wsgi::apache' do

  shared_examples_for 'apache serving cinder with mod_wsgi' do
    context 'with default parameters' do
      it { is_expected.to contain_class('cinder::params') }
      it { is_expected.to contain_class('apache') }
      it { is_expected.to contain_class('apache::mod::wsgi') }
      it { is_expected.to contain_class('apache::mod::ssl') }
      it { is_expected.to contain_openstacklib__wsgi__apache('cinder_wsgi').with(
        :bind_port                   => 8776,
        :group                       => 'cinder',
        :path                        => '/',
        :servername                  => facts[:fqdn],
        :ssl                         => true,
        :threads                     => 1,
        :user                        => 'cinder',
        :workers                     => facts[:os_workers],
        :wsgi_daemon_process         => 'cinder-api',
        :wsgi_process_group          => 'cinder-api',
        :wsgi_script_dir             => platform_params[:wsgi_script_path],
        :wsgi_script_file            => 'cinder-api',
        :wsgi_script_source          => platform_params[:wsgi_script_source],
        :custom_wsgi_process_options => {},
        :access_log_file             => false,
        :access_log_format           => false,
      )}
    end

    context'when overriding parameters using different ports' do
      let :params do
        {
          :servername                  => 'dummy.host',
          :bind_host                   => '10.42.51.1',
          :port                        => 12345,
          :ssl                         => false,
          :vhost_custom_fragment       => 'Timeout 99',
          :wsgi_process_display_name   => 'cinder-api',
          :workers                     => 37,
          :custom_wsgi_process_options => {
            'python_path' => '/my/python/admin/path',
          },
          :access_log_file             => '/var/log/httpd/access_log',
          :access_log_format           => 'some format',
          :error_log_file              => '/var/log/httpd/error_log'
        }
      end
      it { is_expected.to contain_class('cinder::params') }
      it { is_expected.to contain_class('apache') }
      it { is_expected.to contain_class('apache::mod::wsgi') }
      it { is_expected.to_not contain_class('apache::mod::ssl') }
      it { is_expected.to contain_openstacklib__wsgi__apache('cinder_wsgi').with(
        :bind_host                 => '10.42.51.1',
        :bind_port                 => 12345,
        :group                     => 'cinder',
        :path                      => '/',
        :servername                => 'dummy.host',
        :ssl                       => false,
        :threads                   => 1,
        :user                      => 'cinder',
        :vhost_custom_fragment     => 'Timeout 99',
        :workers                   => 37,
        :wsgi_daemon_process       => 'cinder-api',
        :wsgi_process_display_name => 'cinder-api',
        :wsgi_process_group        => 'cinder-api',
        :wsgi_script_dir           => platform_params[:wsgi_script_path],
        :wsgi_script_file          => 'cinder-api',
        :wsgi_script_source        => platform_params[:wsgi_script_source],
        :custom_wsgi_process_options => {
          'python_path'  => '/my/python/admin/path',
        },
        :access_log_file           => '/var/log/httpd/access_log',
        :access_log_format         => 'some format',
        :error_log_file            => '/var/log/httpd/error_log'
      )}
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :os_workers     => 42,
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
