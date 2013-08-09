#
class cinder::volume::iscsi (
  $iscsi_ip_address,
  $volume_group      = 'cinder-volumes',
  $iscsi_helper      = 'tgtadm'
) {

  include cinder::params

  cinder_config {
    'DEFAULT/iscsi_ip_address': value => $iscsi_ip_address;
    'DEFAULT/iscsi_helper':     value => $iscsi_helper;
    'DEFAULT/volume_group':     value => $volume_group;
  }

  case $iscsi_helper {
    'tgtadm': {
      package { 'tgt':
        ensure => present,
        name   => $::cinder::params::tgt_package_name,
      }

      if($::osfamily == 'RedHat') {
        file_line { 'cinder include':
          path    => '/etc/tgt/targets.conf',
          line    => 'include /etc/cinder/volumes/*',
          match   => '#?include /',
          require => Package['tgt'],
          notify  => Service['tgtd'],
        }
      }

      service { 'tgtd':
        ensure  => running,
        name    => $::cinder::params::tgt_service_name,
        enable  => true,
        require => Class['cinder::volume'],
      }
    }

    default: {
      fail("Unsupported iscsi helper: ${iscsi_helper}.")
    }
  }

}
