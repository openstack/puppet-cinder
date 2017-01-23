require 'spec_helper_acceptance'

describe 'basic cinder' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      include ::openstack_integration
      include ::openstack_integration::repos
      include ::openstack_integration::rabbitmq
      include ::openstack_integration::mysql
      include ::openstack_integration::keystone

      rabbitmq_user { 'cinder':
        admin    => true,
        password => 'an_even_bigger_secret',
        provider => 'rabbitmqctl',
        require  => Class['rabbitmq'],
      }

      rabbitmq_user_permissions { 'cinder@/':
        configure_permission => '.*',
        write_permission     => '.*',
        read_permission      => '.*',
        provider             => 'rabbitmqctl',
        require              => Class['rabbitmq'],
      }

      # Cinder resources
      class { '::cinder':
        default_transport_url => 'rabbit://cinder:an_even_bigger_secret@127.0.0.1/',
        database_connection   => 'mysql+pymysql://cinder:a_big_secret@127.0.0.1/cinder?charset=utf8',
        debug                 => true,
      }
      class { '::cinder::keystone::auth':
        password => 'a_big_secret',
      }
      class { '::cinder::db::mysql':
        password => 'a_big_secret',
      }
      class { '::cinder::keystone::authtoken':
        password => 'a_big_secret',
      }
      class { '::cinder::api':
        default_volume_type => 'iscsi_backend',
        service_name        => 'httpd',
      }
      include ::apache
      class { '::cinder::wsgi::apache':
        ssl => false,
      }
      class { '::cinder::backup': }
      class { '::cinder::ceilometer': }
      class { '::cinder::client': }
      class { '::cinder::quota': }
      class { '::cinder::scheduler': }
      class { '::cinder::scheduler::filter': }
      class { '::cinder::volume': }
      class { '::cinder::cron::db_purge': }
      cinder::type { 'test-type': }
      # TODO: create a backend and spawn a volume
      EOS


      # Run it twice to test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe port(8776) do
      it { is_expected.to be_listening }
    end

    describe cron do
      it { is_expected.to have_entry('1 0 * * * cinder-manage db purge 30 >>/var/log/cinder/cinder-rowsflush.log 2>&1').with_user('cinder') }
    end


  end
end
