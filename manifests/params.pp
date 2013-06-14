#
class cinder::params {

  $cinder_conf = '/etc/cinder/cinder.conf'
  $cinder_paste_api_ini = '/etc/cinder/api-paste.ini'

  if $::osfamily == 'Debian' {
    $package_name       = 'cinder-common'
    $client_package     = 'python-cinderclient'
    $api_package        = 'cinder-api'
    $api_service        = 'cinder-api'
    $scheduler_package  = 'cinder-scheduler'
    $scheduler_service  = 'cinder-scheduler'
    $volume_package     = 'cinder-volume'
    $volume_service     = 'cinder-volume'
    $db_sync_command    = 'cinder-manage db sync'
    $tgt_package_name   = 'tgt'
    $tgt_service_name   = 'tgt'
    $ceph_init_override = '/etc/init/cinder-volume.override'

  } elsif($::osfamily == 'RedHat') {

    $package_name       = 'openstack-cinder'
    $client_package     = 'python-cinderclient'
    $api_package        = false
    $api_service        = 'openstack-cinder-api'
    $scheduler_package  = false
    $scheduler_service  = 'openstack-cinder-scheduler'
    $volume_package     = false
    $volume_service     = 'openstack-cinder-volume'
    $db_sync_command    = 'cinder-manage db sync'
    $tgt_package_name   = 'scsi-target-utils'
    $tgt_service_name   = 'tgtd'
    $ceph_init_override = '/etc/sysconfig/openstack-cinder-volume'

  } else {
    fail("unsuported osfamily ${::osfamily}, currently Debian and Redhat are the only supported platforms")
  }
}
