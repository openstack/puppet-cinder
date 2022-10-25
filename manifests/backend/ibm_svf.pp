#
# == Define: cinder::backend::ibm_svf
#
# Setup Cinder to use the IBM Spectrum Virtualize Family(Svf) Driver
# Compatible for multiple backends
#
# == Parameters
#
# [*san_ip*]
#   (required) IP address of IBM Svf SAN controller.
#
# [*san_login*]
#   (required) Username for IBM Svf SAN controller.
#
# [*san_password*]
#   (required) Password for IBM Svf SAN controller.
#
# [*storwize_svc_volpool_name*]
#   (required) Comma separated list of storage pools for volumes.
#
# [*storwize_svc_allow_tenant_qos*]
#   (optional) Allow tenants to specify QoS on create.
#   Defaults to $::os_service_default.
#
# [*storwize_svc_connection_protocol*]
#   (optional) The Storage protocol, iSCSI or FC.
#   This determines the Volume Driver to be
#   configured; StorwizeSVCISCSIDriver or StorwizeSVCFCDriver.
#   Defaults to 'iSCSI'
#
# [*storwize_svc_iscsi_chap_enabled*]
#   (optional) Configure CHAP authentication for iSCSI connections.
#   Defaults to $::os_service_default.
#
# [*storwize_svc_retain_aux_volume*]
#   (optional) Defines an optional parameter to retain an auxiliary volume
#   in a mirror relationship upon deletion of the primary volume or moving
#   it to a non-mirror relationship.
#   Defaults to $::os_service_default.
#
# [*volume_backend_name*]
#   (optional) The storage backend name.
#   Defaults to the name of the backend
#
# [*backend_availability_zone*]
#   (Optional) Availability zone for this volume backend.
#   If not set, the storage_availability_zone option value
#   is used as the default for all backends.
#   Defaults to $::os_service_default.
#
# [*manage_volume_type*]
#   (Optional) Whether or not manage Cinder Volume type.
#   If set to true, a Cinder Volume type will be created
#   with volume_backend_name=$volume_backend_name key/value.
#   Defaults to false.
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend stanza
#   Defaults to: {}
#   Example :
#     { 'ibm_svf_backend/param1' => { 'value' => value1 } }#
#
define cinder::backend::ibm_svf (
  $san_ip,
  $san_login,
  $san_password,
  $storwize_svc_volpool_name,
  $storwize_svc_allow_tenant_qos     = $::os_service_default,
  $storwize_svc_connection_protocol  = 'iSCSI',
  $storwize_svc_iscsi_chap_enabled   = $::os_service_default,
  $storwize_svc_retain_aux_volume    = $::os_service_default,
  $volume_backend_name               = $name,
  $backend_availability_zone         = $::os_service_default,
  $extra_options                     = {},
  $manage_volume_type                = false,
) {

  include cinder::deps
  # NOTE: Svf was earlier called as storwize/svc driver, so the cinder
  # configuration parameters were named accordingly.
  if $storwize_svc_connection_protocol == 'iSCSI' {
    $volume_driver = 'cinder.volume.drivers.ibm.storwize_svc.storwize_svc_iscsi.StorwizeSVCISCSIDriver'
  }
  elsif $storwize_svc_connection_protocol == 'FC' {
    $volume_driver = 'cinder.volume.drivers.ibm.storwize_svc.storwize_svc_fc.StorwizeSVCFCDriver'
  }
  else {
    fail('The cinder::backend::ibm_svf storwize_svc_connection_protocol specified is not valid. It should be iSCSI or FC')
  }

  cinder_config {
    "${name}/volume_backend_name":             value => $volume_backend_name;
    "${name}/backend_availability_zone":       value => $backend_availability_zone;
    "${name}/volume_driver":                   value => $volume_driver;
    "${name}/san_ip":                          value => $san_ip;
    "${name}/san_login":                       value => $san_login;
    "${name}/san_password":                    value => $san_password, secret => true;
    "${name}/storwize_svc_volpool_name":       value => join(any2array($storwize_svc_volpool_name), ',');
    "${name}/storwize_svc_allow_tenant_qos":   value => $storwize_svc_allow_tenant_qos;
    "${name}/storwize_svc_iscsi_chap_enabled": value => $storwize_svc_iscsi_chap_enabled;
    "${name}/storwize_svc_retain_aux_volume":  value => $storwize_svc_retain_aux_volume;
  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => ["volume_backend_name=${volume_backend_name}"],
    }
  }

  create_resources('cinder_config', $extra_options)

}
