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
# [*backend_availability_zone*]
#   (Optional) Availability zone for this volume backend.
#   If not set, the storage_availability_zone option value
#   is used as the default for all backends.
#   Defaults to $facts['os_service_default'].
#
# [*image_volume_cache_enabled*]
#   (Optional) Enable Cinder's image cache function for this backend.
#   Defaults to $facts['os_service_default'],
#
# [*image_volume_cache_max_size_gb*]
#   (Optional) Max size of the image volume cache for this backend in GB.
#   Defaults to $facts['os_service_default'],
#
# [*image_volume_cache_max_count*]
#   (Optional) Max number of entries allowed in the image volume cache.
#   Defaults to $facts['os_service_default'],
#
# [*reserved_percentage*]
#   (Optional) The percentage of backend capacity is reserved.
#   Defaults to $facts['os_service_default'].
#
# [*max_over_subscription_ratio*]
#   (Optional) Representation of the over subscription ratio when thin
#   provisionig is involved.
#   Defaults to $facts['os_service_default'].
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
#   Defaults to $facts['os_service_default']
#
# [*sf_allow_tenant_qos*]
#   (optional) Allow tenants to specify QoS via volume metadata.
#   Defaults to $facts['os_service_default']
#
# [*sf_account_prefix*]
#   (optional) Prefix to use when creating tenant accounts on SolidFire Cluster.
#   Defaults to $facts['os_service_default']
#
# [*sf_api_port*]
#   (optional) Port ID to use to connect to SolidFire API.
#   Defaults to $facts['os_service_default']
#
# [*sf_volume_prefix*]
#   (optional) Create SolidFire volumes with this prefix. Volume names
#   are of the form <sf_volume_prefix><cinder-volume-id>.
#   Defaults to $facts['os_service_default']-
#
# [*sf_svip*]
#   (optional) Overrides default cluster SVIP with the one specified.
#   This is required or deployments that have implemented the use of
#   VLANs for iSCSI networks in their cloud.
#   Defaults to $facts['os_service_default']
#
# [*sf_enable_vag*]
#   (optional) Utilize volume access groups on a per-tenant basis.
#   Defaults to $facts['os_service_default']
#
# [*sf_provisioning_calc*]
#   (optional) Change how SolidFire reports used space and provisioning
#   calculations.
#   Defaults to $facts['os_service_default']
#
# [*sf_cluster_pairing_timeout*]
#   (optional) Sets time in seconds to wait for cluster to complete paring.
#   Defaults to $facts['os_service_default']
#
# [*sf_volume_pairing_timeout*]
#   (optional) Sets time in seconds to wait for a migrating volume to complete
#   paring and sync.
#   Defaults to $facts['os_service_default']
#
# [*sf_api_request_timeout*]
#   (optional) Sets time in seconds to wait for an api request to complete.
#   Defaults to $facts['os_service_default']
#
# [*sf_volume_clone_timeout*]
#   (optional) Sets time in seconds to wait for a clone of a volume or snapshot
#   to complete.
#   Defaults to $facts['os_service_default']
#
# [*sf_volume_create_timeout*]
#   (optional) Sets time in seconds to wait for a create volume operation to
#   complete.
#   Defaults to $facts['os_service_default']
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
  $volume_backend_name            = $name,
  $backend_availability_zone      = $facts['os_service_default'],
  $image_volume_cache_enabled     = $facts['os_service_default'],
  $image_volume_cache_max_size_gb = $facts['os_service_default'],
  $image_volume_cache_max_count   = $facts['os_service_default'],
  $reserved_percentage            = $facts['os_service_default'],
  $max_over_subscription_ratio    = $facts['os_service_default'],
  $volume_driver                  = 'cinder.volume.drivers.solidfire.SolidFireDriver',
  $sf_emulate_512                 = $facts['os_service_default'],
  $sf_allow_tenant_qos            = $facts['os_service_default'],
  $sf_account_prefix              = $facts['os_service_default'],
  $sf_api_port                    = $facts['os_service_default'],
  $sf_volume_prefix               = $facts['os_service_default'],
  $sf_svip                        = $facts['os_service_default'],
  $sf_enable_vag                  = $facts['os_service_default'],
  $sf_provisioning_calc           = $facts['os_service_default'],
  $sf_cluster_pairing_timeout     = $facts['os_service_default'],
  $sf_volume_pairing_timeout      = $facts['os_service_default'],
  $sf_api_request_timeout         = $facts['os_service_default'],
  $sf_volume_clone_timeout        = $facts['os_service_default'],
  $sf_volume_create_timeout       = $facts['os_service_default'],
  Boolean $manage_volume_type     = false,
  Hash $extra_options             = {},
) {

  include cinder::deps

  cinder_config {
    "${name}/volume_backend_name":            value => $volume_backend_name;
    "${name}/backend_availability_zone":      value => $backend_availability_zone;
    "${name}/image_volume_cache_enabled":     value => $image_volume_cache_enabled;
    "${name}/image_volume_cache_max_size_gb": value => $image_volume_cache_max_size_gb;
    "${name}/image_volume_cache_max_count":   value => $image_volume_cache_max_count;
    "${name}/reserved_percentage":            value => $reserved_percentage;
    "${name}/max_over_subscription_ratio":    value => $max_over_subscription_ratio;
    "${name}/volume_driver":                  value => $volume_driver;
    "${name}/san_ip":                         value => $san_ip;
    "${name}/san_login":                      value => $san_login;
    "${name}/san_password":                   value => $san_password, secret => true;
    "${name}/sf_emulate_512":                 value => $sf_emulate_512;
    "${name}/sf_allow_tenant_qos":            value => $sf_allow_tenant_qos;
    "${name}/sf_account_prefix":              value => $sf_account_prefix;
    "${name}/sf_api_port":                    value => $sf_api_port;
    "${name}/sf_volume_prefix":               value => $sf_volume_prefix;
    "${name}/sf_svip":                        value => $sf_svip;
    "${name}/sf_enable_vag":                  value => $sf_enable_vag;
    "${name}/sf_provisioning_calc":           value => $sf_provisioning_calc;
    "${name}/sf_cluster_pairing_timeout":     value => $sf_cluster_pairing_timeout;
    "${name}/sf_volume_pairing_timeout":      value => $sf_volume_pairing_timeout;
    "${name}/sf_api_request_timeout":         value => $sf_api_request_timeout;
    "${name}/sf_volume_clone_timeout":        value => $sf_volume_clone_timeout;
    "${name}/sf_volume_create_timeout":       value => $sf_volume_create_timeout;
  }

  if $manage_volume_type {
    cinder_type { $volume_backend_name:
      ensure     => present,
      properties => ["volume_backend_name=${volume_backend_name}"],
    }
  }

  create_resources('cinder_config', $extra_options)

}
