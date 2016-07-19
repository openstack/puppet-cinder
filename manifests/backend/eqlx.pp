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
#   Defaults to $:os_service_default
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
#   If set to true, a Cinde Volume type will be created
#   with volume_backend_name=$volume_backend_name key/value.
#   Defaults to false.
#
# === DEPRECATED PARAMETERS
#
# [*eqlx_use_chap*]
#   (optional) DEPRECATED.Boolean. Use CHAP authentification for targets. The default
#   value in OpenStack is assumed to be false for this.
#   Defaults to undef
#
# [*eqlx_chap_login*]
#   (optional) DEPRECATED. An existing CHAP account name.
#   Defaults to undef
#
# [*eqlx_chap_password*]
#   (optional) DEPRECATED. The password for the specified CHAP account name.
#   Defaults to undef
#
# [*eqlx_cli_timeout*]
#   (optional) The timeout for the Group Manager cli command execution.
#   Defaults to undef
#
define cinder::backend::eqlx (
  $san_ip,
  $san_login,
  $san_password,
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
  # Deprecated
  $eqlx_use_chap        = undef,
  $eqlx_chap_login      = undef,
  $eqlx_chap_password   = undef,
  $eqlx_cli_timeout     = undef,
) {

  include ::cinder::deps

  if $eqlx_chap_login {
    warning('eqlx_chap_login is deprecated and will be removed after Newton cycle. Please use chap_username instead.')
    $chap_username_real = $eqlx_chap_login
  } else {
    if is_service_default($chap_username) {
      fail('chap_username need to be set.')
    } else {
      $chap_username_real = $chap_username
    }
  }

  if $eqlx_chap_password {
    warning('eqlx_chap_password is deprecated and will be removed after Newton cycle. Please use chap_password instead.')
    $chap_password_real = $eqlx_chap_password
  } else {
    if is_service_default($chap_password) {
      fail('chap_password need to be set.')
    } else {
      $chap_password_real = $chap_password
    }
  }

  if $eqlx_use_chap {
    warning('eqlx_use_chap is deprecated and will be removed after Newton cycle. Please use use_chap_auth instead.')
    $use_chap_auth_real = $eqlx_use_chap
  } else {
    $use_chap_auth_real = $use_chap_auth
  }

  if $eqlx_cli_timeout {
    warning('eqlx_cli_timeout is deprecated and will be removed after Newton cycle. Please use ssh_conn_timeout instead.')
    $ssh_conn_timeout_real = $eqlx_cli_timeout
  } else {
    $ssh_conn_timeout_real = $ssh_conn_timeout
  }

  cinder_config {
    "${name}/volume_backend_name":  value => $volume_backend_name;
    "${name}/volume_driver":        value => 'cinder.volume.drivers.eqlx.DellEQLSanISCSIDriver';
    "${name}/san_ip":               value => $san_ip;
    "${name}/san_login":            value => $san_login;
    "${name}/san_password":         value => $san_password, secret => true;
    "${name}/san_thin_provision":   value => $san_thin_provision;
    "${name}/eqlx_group_name":      value => $eqlx_group_name;
    "${name}/use_chap_auth":        value => $use_chap_auth_real;
    "${name}/ssh_conn_timeout":     value => $ssh_conn_timeout_real;
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
  if !is_service_default($use_chap_auth_real) and $use_chap_auth_real == true {
    cinder_config {
      "${name}/chap_username": value => $chap_username_real;
      "${name}/chap_password": value => $chap_password_real, secret => true;
    }
  }

  create_resources('cinder_config', $extra_options)

}
