# == Class: cinder::volume::solidfire
#
# Configures Cinder volume SolidFire driver.
# Parameters are particular to each volume driver.
#
# === Parameters
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
#   Defaults to True
#
# [*sf_allow_tenant_qos*]
#   (optional) Allow tenants to specify QoS via volume metadata.
#   Defaults to False
#
# [*sf_account_prefix*]
#   (optional) Prefix to use when creating tenant accounts on SolidFire Cluster.
#   Defaults to None, so account name is simply the tenant-uuid
#
# [*sf_template_account_name*]
#   (optional) Account name on the SolidFire Cluster to use as owner of
#   template/cache volumes (created if does not exist)
#   Defaults to openstack-vtemplate
#
# [*sf_allow_template_caching*]
#   (optional) Create an internal cache of copy of images when a bootable
#   volume is created to eliminate fetch from glance and qemu-
#   conversion on subsequent calls.
#   Defaults to false
#
# [*sf_api_port*]
#   (optional) Port ID to use to connect to SolidFire API.
#   Defaults to 443
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend stanza
#   Defaults to: {}
#   Example :
#     { 'solidfire_backend/param1' => { 'value' => value1 } }
#
class cinder::volume::solidfire(
  $san_ip,
  $san_login,
  $san_password,
  $volume_driver             = 'cinder.volume.drivers.solidfire.SolidFireDriver',
  $sf_emulate_512            = true,
  $sf_allow_tenant_qos       = false,
  $sf_account_prefix         = '',
  $sf_template_account_name  = 'openstack-vtemplate',
  $sf_allow_template_caching = false,
  $sf_api_port               = '443',
  $extra_options             = {},
) {

  include ::cinder::deps

  warning('Usage of cinder::volume::solidfire is deprecated, please use
cinder::backend::solidfire instead.')

  cinder::backend::solidfire { 'DEFAULT':
    san_ip                    => $san_ip,
    san_login                 => $san_login,
    san_password              => $san_password,
    volume_driver             => $volume_driver,
    sf_emulate_512            => $sf_emulate_512,
    sf_allow_tenant_qos       => $sf_allow_tenant_qos,
    sf_account_prefix         => $sf_account_prefix,
    sf_template_account_name  => $sf_template_account_name,
    sf_allow_template_caching => $sf_allow_template_caching,
    sf_api_port               => $sf_api_port,
    extra_options             => $extra_options,
  }
}
