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
      # Ubuntu/Debian specific :(
      file { '/etc/tgt/conf.d/cinder.conf':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => 'include /var/lib/cinder/volumes/*',
        notify  => Service['tgtd'],
        require => Package['tgt'],
      }

    }

    default: {
      fail("Unsupported iscsi helper: ${iscsi_helper}.")
    }
  }

}
