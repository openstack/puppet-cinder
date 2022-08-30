require 'spec_helper_acceptance'

describe 'basic cinder' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      include openstack_integration
      include openstack_integration::repos
      include openstack_integration::apache
      include openstack_integration::rabbitmq
      include openstack_integration::mysql
      include openstack_integration::memcached
      include openstack_integration::keystone
      include openstack_integration::cinder
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
