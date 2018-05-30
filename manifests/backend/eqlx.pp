# == define: cinder::backend::eqlx
#
# Configure the Dell EqualLogic driver for cinder.
#
# === Parameters
#
# [*san_ip*]
#   (required) The IP address of the Dell EqualLogic array.
#
# [*san_login*]
#   (required) The account to use for issuing SSH commands.
#
# [*san_password*]
#   (required) The password for the specified SSH account.
#
# [*san_private_key*]
#   (optional) Filename of private key to use for SSH authentication.
#   Defaults to $::os_service_default
#
# [*san_thin_provision*]
#   (optional) Boolean. Whether or not to use thin provisioning for volumes. The
#   default value in OpenStack is true.
#   Defaults to $::os_service_default
#
# [*volume_backend_name*]
#   (optional) The backend name.
#   Defaults to the name of the resource
#
# [*eqlx_group_name*]
#   (optional) The CLI prompt message without '>'.
#   Defaults to $::os_service_default
#
# [*eqlx_pool*]
#   (optional) The pool in which volumes will be created.
#   Defaults to $::os_service_default
#
# [*eqlx_cli_max_retries*]
#   (optional) The maximum retry count for reconnection.
#   Defaults to $::os_service_default
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend stanza
#   Defaults to: {}
#   Example :
#     { 'eqlx_backend/param1' => { 'value' => value1 } }
#
# [*chap_username*]
#   (required) (String) CHAP user name.
#
# [*chap_password*]
#   (required) (String) Password for specified CHAP account name.
#
# [*use_chap_auth*]
#   (optional) (Boolean) Option to enable/disable CHAP authentication for
#   targets.
#   Defaults to $::os_service_default
#
# [*ssh_conn_timeout*]
#   (optional) The timeout for the Group Manager cli command execution.
#   Defaults to $::os_service_default
#
# [*manage_volume_type*]
#   (Optional) Whether or not manage Cinder Volume type.
#   If set to true, a Cinder Volume type will be created
#   with volume_backend_name=$volume_backend_name key/value.
#   Defaults to false.
#
define cinder::backend::eqlx (
  $san_ip,
  $san_login,
  $san_password,
  $san_private_key      = $::os_service_default,
  $san_thin_provision   = $::os_service_default,
  $volume_backend_name  = $name,
  $eqlx_group_name      = $::os_service_default,
  $eqlx_pool            = $::os_service_default,
  $eqlx_cli_max_retries = $::os_service_default,
  $extra_options        = {},
  $chap_username        = $::os_service_default,
  $chap_password        = $::os_service_default,
  $use_chap_auth        = $::os_service_default,
  $ssh_conn_timeout     = $::os_service_default,
  $manage_volume_type   = false,
) {

  include ::cinder::deps

  if is_service_default($chap_username) {
    fail('chap_username need to be set.')
  }

  if is_service_default($chap_password) {
    fail('chap_password need to be set.')
  }

  cinder_config {
    "${name}/volume_backend_name":  value => $volume_backend_name;
    "${name}/volume_driver":        value => 'cinder.volume.drivers.dell_emc.ps.PSSeriesISCSIDriver';
    "${name}/san_ip":               value => $san_ip;
    "${name}/san_login":            value => $san_login;
    "${name}/san_password":         value => $san_password, secret => true;
    "${name}/san_private_key":      value => $san_private_key;
    "${name}/san_thin_provision":   value => $san_thin_provision;
    "${name}/eqlx_group_name":      value => $eqlx_group_name;
    "${name}/use_chap_auth":        value => $use_chap_auth;
    "${name}/ssh_conn_timeout":     value => $ssh_conn_timeout;
    "${name}/eqlx_cli_max_retries": value => $eqlx_cli_max_retries;
    "${name}/eqlx_pool":            value => $eqlx_pool;
  }

  if $manage_volume_type {
    cinder_type { $name:
      ensure     => present,
      properties => ["volume_backend_name=${name}"],
    }
  }

  # the default for this is false
  if !is_service_default($use_chap_auth) and $use_chap_auth == true {
    cinder_config {
      "${name}/chap_username": value => $chap_username;
      "${name}/chap_password": value => $chap_password, secret => true;
    }
  }

  create_resources('cinder_config', $extra_options)

}
