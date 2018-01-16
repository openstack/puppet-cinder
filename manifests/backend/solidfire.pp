# == Class: cinder::backend::solidfire
#
# Configures Cinder volume SolidFire driver.
# Parameters are particular to each volume driver.
#
# === Parameters
#
# [*volume_backend_name*]
#   (optional) Allows for the volume_backend_name to be separate of $name.
#   Defaults to: $name
#
# [*volume_driver*]
#   (optional) Setup cinder-volume to use SolidFire volume driver.
#   Defaults to 'cinder.volume.drivers.solidfire.SolidFireDriver'
#
# [*san_ip*]
#   (required) IP address of SolidFire clusters MVIP.
#
# [*san_login*]
#   (required) Username for SolidFire admin account.
#
# [*san_password*]
#   (required) Password for SolidFire admin account.
#
# [*sf_emulate_512*]
#   (optional) Use 512 byte emulation for volumes.
#   Defaults to $::os_service_default
#
# [*sf_allow_tenant_qos*]
#   (optional) Allow tenants to specify QoS via volume metadata.
#   Defaults to $::os_service_default
#
# [*sf_account_prefix*]
#   (optional) Prefix to use when creating tenant accounts on SolidFire Cluster.
#   Defaults to $::os_service_default
#
# [*sf_template_account_name*]
#   (optional) Account name on the SolidFire Cluster to use as owner of
#   template/cache volumes (created if does not exist)
#   Defaults to $::os_service_default
#
# [*sf_allow_template_caching*]
#   (optional) Create an internal cache of copy of images when a bootable
#   volume is created to eliminate fetch from glance and qemu-
#   conversion on subsequent calls.
#   Defaults to $::os_service_default
#
# [*sf_api_port*]
#   (optional) Port ID to use to connect to SolidFire API.
#   Defaults to $::os_service_default
#
# [*sf_volume_prefix*]
#   (optional) Create SolidFire volumes with this prefix. Volume names
#   are of the form <sf_volume_prefix><cinder-volume-id>.
#   Defaults to $::os_service_default-
#
# [*sf_svip*]
#   (optional) Overrides default cluster SVIP with the one specified.
#   This is required or deployments that have implemented the use of
#   VLANs for iSCSI networks in their cloud.
#   Defaults to $::os_service_default
#
# [*sf_enable_volume_mapping*]
#   (optional) Create an internal mapping of volume IDs and account.
#   Optimizes lookups and performance at the expense of memory, very
#   large deployments may want to consider setting to False.
#   Defaults to $::os_service_default
#
# [*sf_enable_vag*]
#   (optional) Utilize volume access groups on a per-tenant basis.
#   Defaults to $::os_service_default
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
#     { 'solidfire_backend/param1' => { 'value' => value1 } }
#
define cinder::backend::solidfire(
  $san_ip,
  $san_login,
  $san_password,
  $volume_backend_name       = $name,
  $volume_driver           = 'cinder.volume.drivers.solidfire.SolidFireDriver',
  $sf_emulate_512            = $::os_service_default,
  $sf_allow_tenant_qos       = $::os_service_default,
  $sf_account_prefix         = $::os_service_default,
  $sf_template_account_name  = $::os_service_default,
  $sf_allow_template_caching = $::os_service_default,
  $sf_api_port               = $::os_service_default,
  $sf_volume_prefix          = $::os_service_default,
  $sf_svip                   = $::os_service_default,
  $sf_enable_volume_mapping  = $::os_service_default,
  $sf_enable_vag             = $::os_service_default,
  $manage_volume_type        = false,
  $extra_options             = {},
) {

  include ::cinder::deps

  cinder_config {
    "${name}/volume_backend_name":         value => $volume_backend_name;
    "${name}/volume_driver":               value => $volume_driver;
    "${name}/san_ip":                      value => $san_ip;
    "${name}/san_login":                   value => $san_login;
    "${name}/san_password":                value => $san_password, secret => true;
    "${name}/sf_emulate_512":              value => $sf_emulate_512;
    "${name}/sf_allow_tenant_qos":         value => $sf_allow_tenant_qos;
    "${name}/sf_account_prefix":           value => $sf_account_prefix;
    "${name}/sf_template_account_name":    value => $sf_template_account_name;
    "${name}/sf_allow_template_caching":   value => $sf_allow_template_caching;
    "${name}/sf_api_port":                 value => $sf_api_port;
    "${name}/sf_volume_prefix":            value => $sf_volume_prefix;
    "${name}/sf_svip":                     value => $sf_svip;
    "${name}/sf_enable_volume_mapping":    value => $sf_enable_volume_mapping;
    "${name}/sf_enable_vag":               value => $sf_enable_vag;
  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => ["volume_backend_name=${volume_backend_name}"],
    }
  }

  create_resources('cinder_config', $extra_options)

}
