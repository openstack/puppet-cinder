# == Class: cinder::params
#
# Parameters for puppet-cinder
#
class cinder::params {
  include openstacklib::defaults

  $client_package            = 'python3-cinderclient'
  $user                      = 'cinder'
  $group                     = 'cinder'
  $cinder_wsgi_script_source = '/usr/bin/cinder-wsgi'

  case $facts['os']['family'] {
    'Debian': {
      $package_name              = 'cinder-common'
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
      $nfs_client_package_name   = 'nfs-common'
      $ceph_common_package_name  = 'ceph-common'
      $target_helper             = 'tgtadm'
      $lio_package_name          = 'targetcli'
      $lock_path                 = '/var/lock/cinder'
      $cinder_wsgi_script_path   = '/usr/lib/cgi-bin/cinder'
      $nvme_cli_package_name     = 'nvme-cli'
      $nvmetcli_package_name     = undef
    }
    'RedHat': {
      $package_name              = 'openstack-cinder'
      $api_package               = undef
      $api_service               = 'openstack-cinder-api'
      $backup_package            = undef
      $backup_service            = 'openstack-cinder-backup'
      $scheduler_package         = undef
      $scheduler_service         = 'openstack-cinder-scheduler'
      $volume_package            = undef
      $volume_service            = 'openstack-cinder-volume'
      $db_sync_command           = 'cinder-manage db sync'
      $tgt_package_name          = 'scsi-target-utils'
      $tgt_service_name          = 'tgtd'
      $nfs_client_package_name   = 'nfs-utils'
      $ceph_common_package_name  = 'ceph-common'
      $target_helper             = 'lioadm'
      $lio_package_name          = 'targetcli'
      $lock_path                 = '/var/lib/cinder/tmp'
      $cinder_wsgi_script_path   = '/var/www/cgi-bin/cinder'
      $nvme_cli_package_name     = 'nvme-cli'
      $nvmetcli_package_name     = 'nvmetcli'
    }
    default: {
      fail("Unsupported osfamily: ${facts['os']['family']}")
    }
  }
}
