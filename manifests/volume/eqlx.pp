# == define: cinder::volume::eqlx
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
#   (optional) Whether or not to use thin provisioning for volumes.
#   Defaults to $::os_service_default
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
# === DEPRECATED PARAMETERS
#
# [*eqlx_use_chap*]
#   (optional) DEPREATED. Use CHAP authentification for targets?
#   Defaults to undef
#
# [*eqlx_chap_login*]
#   (optional) DEPREATED. An existing CHAP account name.
#   Defaults to undef
#
# [*eqlx_chap_password*]
#   (optional) DEPREATED. The password for the specified CHAP account name.
#   Defaults to undef
#
# [*eqlx_cli_timeout*]
#   (optional) DEPRECATED. The timeout for the Group Manager cli command execution.
#   Defaults to undef
#
class cinder::volume::eqlx (
  $san_ip,
  $san_login,
  $san_password,
  $san_thin_provision   = $::os_service_default,
  $eqlx_group_name      = $::os_service_default,
  $eqlx_pool            = $::os_service_default,
  $eqlx_cli_max_retries = $::os_service_default,
  $extra_options        = {},
  $chap_username        = $::os_service_default,
  $chap_password        = $::os_service_default,
  $use_chap_auth        = $::os_service_default,
  $ssh_conn_timeout     = $::os_service_default,
  # DEPRECATED
  $eqlx_use_chap        = undef,
  $eqlx_chap_login      = undef,
  $eqlx_chap_password   = undef,
  $eqlx_cli_timeout     = undef,
) {

  include ::cinder::deps

  warning('Usage of cinder::volume::eqlx is deprecated, please use
cinder::backend::eqlx instead.')

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

  cinder::backend::eqlx { 'DEFAULT':
    san_ip               => $san_ip,
    san_login            => $san_login,
    san_password         => $san_password,
    san_thin_provision   => $san_thin_provision,
    eqlx_group_name      => $eqlx_group_name,
    eqlx_pool            => $eqlx_pool,
    ssh_conn_timeout     => $ssh_conn_timeout_real,
    eqlx_cli_max_retries => $eqlx_cli_max_retries,
    extra_options        => $extra_options,
    chap_username        => $chap_username_real,
    chap_password        => $chap_password_real,
    use_chap_auth        => $use_chap_auth_real,
  }

}
