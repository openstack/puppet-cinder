# == Class: cinder::params
#
class cinder::params {
  include ::openstacklib::defaults

  if $::osfamily == 'Debian' {
    $package_name              = 'cinder-common'
    $client_package            = 'python-cinderclient'
    $api_package               = 'cinder-api'
    $api_service               = 'cinder-api'
    $backup_package            = 'cinder-backup'
    $backup_service            = 'cinder-backup'
    $scheduler_package         = 'cinder-scheduler'
    $scheduler_service         = 'cinder-scheduler'
    $volume_package            = 'cinder-volume'
    $volume_service            = 'cinder-volume'
    $db_sync_command           = 'cinder-manage db sync'
    $tgt_package_name          = 'tgt'
    $tgt_service_name          = 'tgt'
    $ceph_init_override        = '/etc/init/cinder-volume.override'
    $iscsi_helper              = 'tgtadm'
    $lio_package_name          = 'targetcli'
    $lock_path                 = '/var/lock/cinder'
    $cinder_wsgi_script_path   = '/usr/lib/cgi-bin/cinder'
    $cinder_wsgi_script_source = '/usr/bin/cinder-wsgi'

  } elsif($::osfamily == 'RedHat') {

    $package_name              = 'openstack-cinder'
    $client_package            = 'python-cinderclient'
    $api_package               = false
    $api_service               = 'openstack-cinder-api'
    $backup_package            = false
    $backup_service            = 'openstack-cinder-backup'
    $scheduler_package         = false
    $scheduler_service         = 'openstack-cinder-scheduler'
    $volume_package            = false
    $volume_service            = 'openstack-cinder-volume'
    $db_sync_command           = 'cinder-manage db sync'
    $tgt_package_name          = 'scsi-target-utils'
    $tgt_service_name          = 'tgtd'
    $ceph_init_override        = '/etc/sysconfig/openstack-cinder-volume'
    $lio_package_name          = 'targetcli'
    $lock_path                 = '/var/lib/cinder/tmp'
    $cinder_wsgi_script_path   = '/var/www/cgi-bin/cinder'
    $cinder_wsgi_script_source = '/usr/bin/cinder-wsgi'

    case $::operatingsystem {
      'RedHat', 'CentOS', 'Scientific', 'OracleLinux': {
        if (versioncmp($::operatingsystemmajrelease, '7') >= 0) {
          $iscsi_helper = 'lioadm'
        } else {
          $iscsi_helper = 'tgtadm'
        }
      }
      default: {
        $iscsi_helper = 'lioadm'
      }
    }

  } else {
    fail("unsupported osfamily ${::osfamily}, currently Debian and Redhat are the only supported platforms")
  }
}
