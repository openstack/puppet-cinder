require 'spec_helper'

describe 'Cinder::CephConf' do
  describe 'valid types' do
    context 'with valid types' do
      [
        '/etc/ceph/ceph.conf',
        '/etc/ceph.conf',
        '/ceph.conf',
        '/etc/ceph/foo/ceph.conf',
        '/etc/ceph/foo.conf',
      ].each do |value|
        describe value.inspect do
          it { is_expected.to allow_value(value) }
        end
      end
    end
  end

  describe 'invalid types' do
    context 'with garbage inputs' do
      [
        'etc/ceph/ceph.conf',
        'ceph.conf',
        '/etc/ceph/ceph.config',
        '/etc/ceph/ceph',
        '<SERVICE DEFAULT>',
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
