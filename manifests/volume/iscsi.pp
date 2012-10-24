#
class cinder::volume::iscsi (
  $volume_group = 'cinder-volumes',
  $iscsi_helper = 'tgtadm'
) {

  include cinder::params

  cinder_config {
    'DEFAULT/iscsi_helper': value => $iscsi_helper;
    'DEFAULT/volume_group': value => $volume_group;
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
    }

    default: {
      fail("Unsupported iscsi helper: ${iscsi_helper}.")
    }
  }

}
