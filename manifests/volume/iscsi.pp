#
class cinder::volume::iscsi (
  $iscsi_settings   = false,
  $iscsi_helper     = 'tgtadm'
) {

  include cinder::params

  if $iscsi_settings {
    multini($::cinder::params::cinder_conf, $iscsi_settings)
  }

  case $iscsi_helper {
    'tgtadm': {
      package { 'tgt':
        name   => $::cinder::params::tgt_package_name,
        ensure => present,
      }
      service { 'tgtd':
        name    => $::cinder::params::tgt_service_name,
        ensure  => running,
        enable  => true,
        require => Class['cinder::volume'],
      }

      multini($::cinder::params::cinder_conf, { 'DEFAULT' => { 'iscsi_helper' => 'tgtadm' } } )
    }

    default: {
      fail("Unsupported iscsi helper: ${iscsi_helper}.")
    }
  }
  
}
