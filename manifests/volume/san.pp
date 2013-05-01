# == Class: cinder::volume::san
#
# Configures Cinder volume SAN driver.
# Parameters are particular to each volume driver.
#
# === Parameters
#
# [*volume_driver*]
#   (required) Setup cinder-volume to use volume driver.
#
# [*san_thin_provision*]
#   (optional) Use thin provisioning for SAN volumes? Defaults to true.
#
# [*san_ip*]
#   (optional) IP address of SAN controller.
#
# [*san_login*]
#   (optional) Username for SAN controller. Defaults to 'admin'.
#
# [*san_password*]
#   (optional) Password for SAN controller.
#
# [*san_private_key*]
#   (optional) Filename of private key to use for SSH authentication.
#
# [*san_clustername*]
#   (optional) Cluster name to use for creating volumes.
#
# [*san_ssh_port*]
#   (optional) SSH port to use with SAN. Defaults to 22.
#
# [*san_is_local*]
#   (optional) Execute commands locally instead of over SSH
#   use if the volume service is running on the SAN device.
#
# [*ssh_conn_timeout*]
#   (optional) SSH connection timeout in seconds. Defaults to 30.
#
# [*ssh_min_pool_conn*]
#   (optional) Minimum ssh connections in the pool.
#
# [*ssh_min_pool_conn*]
#   (optional) Maximum ssh connections in the pool.
#
class cinder::volume::san (
  $volume_driver,
  $san_thin_provision = true,
  $san_ip             = undef,
  $san_login          = 'admin',
  $san_password       = undef,
  $san_private_key    = undef,
  $san_clustername    = undef,
  $san_ssh_port       = 22,
  $san_is_local       = false,
  $ssh_conn_timeout   = 30,
  $ssh_min_pool_conn  = 1,
  $ssh_max_pool_conn  = 5
) {

  cinder_config {
    'DEFAULT/volume_driver':      value => $volume_driver;
    'DEFAULT/san_thin_provision': value => $san_thin_provision;
    'DEFAULT/san_ip':             value => $san_ip;
    'DEFAULT/san_login':          value => $san_login;
    'DEFAULT/san_password':       value => $san_password;
    'DEFAULT/san_private_key':    value => $san_private_key;
    'DEFAULT/san_clustername':    value => $san_clustername;
    'DEFAULT/san_ssh_port':       value => $san_ssh_port;
    'DEFAULT/san_is_local':       value => $san_is_local;
    'DEFAULT/ssh_conn_timeout':   value => $ssh_conn_timeout;
    'DEFAULT/ssh_min_pool_conn':  value => $ssh_min_pool_conn;
    'DEFAULT/ssh_max_pool_conn':  value => $ssh_max_pool_conn;
  }
}
