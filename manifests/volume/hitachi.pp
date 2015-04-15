# == define: cinder::backend::hitachi
#
# Configures Cinder to use the hitachi volume driver
# Compatible for multiple backends
#
# === Parameters
#
# [*hitachi_serial_number*] (VSP G1000, VSP, HUSVM)
#   (required) Specity the product number of the storage device when using 
#   VSP G1000/VSP/HUSVM. If the hitachi_unit_name parameter is also specified,
#   the parameter specification is invalid and startp of the backend would fail.
#
# [*hitachi_unit_name*] (HUS100)
#   (required) Specify the storage device name when using HUS100. If the
#   hitachi_serial_number parameter is also specified, the parameter specification
#   is invalid and startup of the backend will fail.
#
# [*hitachi_pool_id*]
#   (required) Specify the ID of the DP pool (integer) that stores LDEVs for volumes
#   (or snapshots).
#
# [*hitachi_thin_pool_id*]
#   (optional) Specify the ID of the DP pool (integer) that stores LDEVs for Thin Image
#   or Copy-on-Write Snapshot. For VSP G1000/VSP/HUSVM, specify a pool ID for Think Image.
#   For HUS100, specify a DP pool ID. (The pool ID specified for the hitachi_pool_id
#   parameter can also be used). If nothing is specified, Thin Image or Copy-on-Write
#   Snapshot cannot be used to copy volumes.
#
# [*hitachi_ldev_range*]
#   (optional) Specify the range of usable LDEV numbers by using integer-value-1 -
#   integer-value-2 format. The value of the interger-value-1 must be equal to or smaller
#   than the value of integer-value-2. If nothing is specified, the entire range permitted by
#   the storage is used. You can specify integer values by using a decimal format or 
#   colon-separated hexadecimal format (xx:vv:zz).
#
# [*hitachi_horcm_numbers*] (VSP G1000, VSP, HUSVM)
#   (optional) Specify different numbers (separated by a comma) for the operating instance 
#   number and pairing instance number used by RAID Manager. If nothing is specified, the operating
#   instance number and pairing instance number are set to 200 and 201 respectively. Note that in
#   the case of existing other backends, the operating instance number and pairing instance number
#   must be shared with other backends. A non-default instance number that is already used by other
#   applications in the Controller node must not be used.
#
# [*hitachi_horcm_user*] (VSP G1000, VSP, HUSVM)
#  (required) Specify the user name that the instance used by RAID Manager used to login to the 
#  storage. If HBSD manages multiple storage devices (VSP G1000/VSP/HUSVM), create the same login
#  user name for all managed storage systems so that the login user name is shared with other backends.
#
# [*hitachi_horcm_password*] (VSP G1000, VSP, HUSVM)
#  (required) Specify the password that the instance used by RAID Manager used to log in to the storage.
#
# [*hitachi_horcm_add_conf*] (VSP G1000, VSP, HUSVM)
#  (optional) Specify True or False to determine whether the following is performed when HBSD starts:
#  - Create configuraiton definition file horcmXXX.conf (XXX: Operating or pairing instance number) 
#  for the instance used by RAID Manager if the file is not found.
#  - Add a command device if one has not been registered. If True(default) is specified, the 
#  command device is registered automatically.
#
# [*hitachi_target_ports*]
#  (optional) Specify the storage controller port number (for example, 0A) for which the host group used to
#  attach volumes is searched. To use multipath connection, specify controller port names separately by a comma
#  (for example, 0A,1A). If nothing is specified, HBSD searches for all ports of the storage. In this case, a
#  search might take some time.
#
# [*hitachi_group_request*] (HUS100)
#  (optional) Specify True to automatically create an iSCSI group if an iSCSI group corresponding to the 
#  compute node des not exist for the ports specified for the hitachi_target_ports parameter. If you do not
#  want to create an iSCSI group, specify False(default).
#
# [*hitachi_group_range*] 
#  (optional) Specify the range of GUIs that can be specified for creating a pairing host group or iSCSI target,
#  using integer-value-1 - integer-value-2 format. The value of integer-value-1 must be equal to or smaller than the
#  value of integer-value-2. If nothing is specified, the entire range permitted by the storage is used.
#
# [*hitachi_add_chap_user*] (HUS100 (iSCSI))
#  (optional) Specify True or False to determine whether a CHAP user is created if the CHAP user specified for the 
#  hitachi_auth_user parameter does not exist when the iSCSI target is registered. Specify False (default) if you do not
#  want to create a CHAP user.
#
# [*hitachi_auth_method*] (HUS100 (iSCSI))
#  (optional) Specify None, CHAP None, or CHAP as the iSCSI target authentication method. If multiple ports are
#  specified for the hitachi_target_ports parameter, the same authentication methos applies to these ports.
#
# [*hitachi_auth_user*] (HUS100 (iSCSI))
#  (optional) Specify the CHAP user name used for authentication for the iSCSI target. Character strins that can be
#  specified are defined in the SNM2 specifications. See the relevant manual. If nothing is specified. HBSD-CHAP-user is set.
#
# [*hitachi_auth_password*] (HUS100 (iSCSI))
#  (optional) Specify the password for the hitachi_auth_user setting. Character strings that can be specified are defined
#  in the SNM2 specifications. See the relevant manual. If nothing is specified, HBSD-CHAP-password is set.
#
# [*hitachi_default_copy_method*]
#  (optional) Specify the volume copy method. You can specify FULL(ShadowImage) or THIN(Thin Image or Copy-on-Write Snapshot).
#  If nothing is specified, FULL is used.
#
# [*hitachi_copy_speed*]
#  (optional) Specify the copy speed for copying volumes by using the ShadowImage function. You can specify a value in the
#  range from 1 to 15. If nothing is specified, 3 is set. Specify 1 or 2 to select slow copy speed. Specify 3 to select
#  normal speed, and specify 4 or lager to specify high speed(prior).
#
# [*hitachi_copy_check_interval*]
#  (optional) Specify the interval (seconds) at which pair creation is confirmed during volume copy operation. You 
#  can specify a value in the range from 1 to 600. If nothing is specified, 3 (seconds) is set.
#
# [*hitachi_async_copy_check_interval*]
#  (optional) Specify the interval(seconds) at which ShadowImage pair synchronization is confirmed. You can specify a
#  value in the range from 1 to 600. If nothing is specified, 10 (seconds) is set.
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend stanza
#   Defaults to: {}
#   Example :
#     { 'hitachi_backend/param1' => { 'value' => value1 } }
#
# === Examples
#
#  cinder::backend::hitachi { 'HDSBackend':
#    hitachi_pool_id            => '1',
#    hitachi_vol_pool_id        => '0',
#    hitachi_vol_thin_pool_id   => '0',
#    hitachi_target_ports       => 'CL1-A',
#    hitachi_default_copy_method        => 'THIN',
#    hitachi_horcm_user         => 'maintenance',
#    hitachi_horcm_password     => 'maintenance',
#    hitachi_rminst_user         => 'maintenance',
#    hitachi_rminst_password     => 'maintenance',
#    hitachi_serial_number     => '211975',
#    hitachi_rminst_add_conf     => 'False',
#    hitachi_horcm_add_conf     => 'False',
#    hitachi_zoning_request     => 'true',
#    hitachi_group_request     => 'true',
#    hitachi_debug_level     => 'debug',
#    volume_backend_name    => 'hus100_backend',
#  }
#
# === Copyright
#
# Copyright 2015 Hitachi Data System 
#
define cinder::volume::hitachi (
      $hitachi_pool_id            = '1',
      $hitachi_vol_pool_id        = '0',
      $hitachi_vol_thin_pool_id   = '0',
      $hitachi_target_ports       = 'CL1-A',
      $hitachi_default_copy_method        = 'THIN',
      $hitachi_copy_speed        = '3',
      $hitachi_copy_check_interval        = '3',
      $hitachi_async_copy_check_interval        = '10',
      $hitachi_horcm_user         = 'maintenance',
      $hitachi_horcm_password     = 'maintenance',
      $hitachi_horcm_numbers     = '200,201',
      $hitachi_rminst_user         = 'maintenance',
      $hitachi_rminst_password     = 'maintenance',
      $hitachi_serial_number     = '211975',
      $hitachi_unit_name           = '',
      $hitachi_ldev_range          = '',
      $hitachi_rminst_add_conf     = 'False',
      $hitachi_horcm_add_conf     = 'False',
      $hitachi_zoning_request     = 'true',
      $hitachi_group_request     = 'true',
      $hitachi_group_range     = '',
      $hitachi_add_chap_user   = 'False',
      $hitachi_auth_method   = 'None',
      $hitachi_auth_user   = '',
      $hitachi_auth_password   = '',
      $hitachi_debug_level     = 'debug',
      $volume_backend_name    = $name, 
      $extra_options                = {},
) {

 cinder::backend::hitachi { 'DEFAULT':
    hitachi_pool_id => $hitachi_pool_id,
    hitachi_vol_pool_id => $hitachi_vol_pool_id,
    hitachi_vol_thin_pool_id => $hitachi_vol_thin_pool_id,
    hitachi_target_ports => $hitachi_target_ports,
    hitachi_default_copy_method => $hitachi_default_copy_method,
    hitachi_copy_speed => $hitachi_copy_speed,
    hitachi_copy_check_interval => $hitachi_copy_check_interval,
    hitachi_async_copy_check_interval => $hitachi_async_copy_check_interval,
    hitachi_horcm_user => $hitachi_horcm_user,
    hitachi_horcm_password => $hitachi_horcm_password,
    hitachi_horcm_numbers => $hitachi_horcm_numbers,
    hitachi_rminst_user => $hitachi_rminst_user,
    hitachi_rminst_password => $hitachi_rminst_password,
    hitachi_serial_number => $hitachi_serial_number,
    hitachi_unit_name => $hitachi_unit_name,
    hitachi_ldev_range => $hitachi_ldev_range,
    hitachi_rminst_add_conf => $hitachi_rminst_add_conf,
    hitachi_horcm_add_conf => $hitachi_horcm_add_conf,
    hitachi_zoning_request  => $hitachi_zoning_request,
    hitachi_group_request => $hitachi_group_request,
    hitachi_group_range => $hitachi_group_range,
    hitachi_add_chap_user => $hitachi_add_chap_user,
    hitachi_auth_method => $hitachi_auth_method,
    hitachi_auth_user => $hitachi_auth_user,
    hitachi_auth_password => $hitachi_auth_password,
    hitachi_debug_level => $hitachi_debug_level,
    volume_backend_name => $volume_backend_name,
    extra_options  => $extra_options,
  }
}
