#
class cinder::params {

  $cinder_conf = '/etc/cinder/cinder.conf'
  $cinder_paste_api_ini = '/etc/cinder/api-paste.ini'

  if $::osfamily == 'Debian' {
    $package_name      = 'cinder-common'
    $api_package       = 'cinder-api'
    $api_service       = 'cinder-api'
    $scheduler_package = 'cinder-scheduler'
    $scheduler_service = 'cinder-scheduler'
    $volume_package    = 'cinder-volume'
    $volume_service    = 'cinder-volume'
    $db_sync_command   = 'cinder-manage db sync'

    $tgt_package_name  = 'tgt'
    $tgt_service_name  = 'tgt'
  } else {
    fail("unsuported osfamily ${::osfamily}, currently Debian is the only supported platform")
  }
}
