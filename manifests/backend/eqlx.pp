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
# [*eqlx_use_chap*]
#   (optional) Boolean. Use CHAP authentification for targets. The default
#   value in OpenStack is assumed to be false for this.
#   Defaults to $::os_service_default
#
# [*eqlx_chap_login*]
#   (optional) An existing CHAP account name.
#   Defaults to 'chapadmin'
#
# [*eqlx_chap_password*]
#   (optional) The password for the specified CHAP account name.
#   Defaults to '12345'
#
# [*eqlx_cli_timeout*]
#   (optional) The timeout for the Group Manager cli command execution.
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
define cinder::backend::eqlx (
  $san_ip,
  $san_login,
  $san_password,
  $san_thin_provision   = $::os_service_default,
  $volume_backend_name  = $name,
  $eqlx_group_name      = $::os_service_default,
  $eqlx_pool            = $::os_service_default,
  $eqlx_use_chap        = $::os_service_default, # false
  $eqlx_chap_login      = 'chapadmin',
  $eqlx_chap_password   = '12345',
  $eqlx_cli_timeout     = $::os_service_default,
  $eqlx_cli_max_retries = $::os_service_default,
  $extra_options        = {},
) {

  if !is_service_default($san_thin_provision) {
    validate_bool($san_thin_provision)
  }

  if !is_service_default($eqlx_use_chap) {
    validate_bool($eqlx_use_chap)
  }

  if $eqlx_chap_login == 'chapadmin' {
    warning('The OpenStack default value of eqlx_chap_login differs from the puppet module default of "chapadmin" and will be changed to the upstream OpenStack default in N-release.')
  }

  if $eqlx_chap_password == '12345' {
    warning('The OpenStack default value of eqlx_chap_password differs from the puppet module default of "12345" and will be changed to the upstream OpenStack default in N-release.')
  }



  cinder_config {
    "${name}/volume_backend_name":  value => $volume_backend_name;
    "${name}/volume_driver":        value => 'cinder.volume.drivers.eqlx.DellEQLSanISCSIDriver';
    "${name}/san_ip":               value => $san_ip;
    "${name}/san_login":            value => $san_login;
    "${name}/san_password":         value => $san_password, secret => true;
    "${name}/san_thin_provision":   value => $san_thin_provision;
    "${name}/eqlx_group_name":      value => $eqlx_group_name;
    "${name}/eqlx_use_chap":        value => $eqlx_use_chap;
    "${name}/eqlx_cli_timeout":     value => $eqlx_cli_timeout;
    "${name}/eqlx_cli_max_retries": value => $eqlx_cli_max_retries;
    "${name}/eqlx_pool":            value => $eqlx_pool;
  }

  # the default for this is false
  if !is_service_default($eqlx_use_chap) and $eqlx_use_chap == true {
    cinder_config {
      "${name}/eqlx_chap_login":      value => $eqlx_chap_login;
      "${name}/eqlx_chap_password":   value => $eqlx_chap_password, secret => true;
    }
  }

  create_resources('cinder_config', $extra_options)

}
