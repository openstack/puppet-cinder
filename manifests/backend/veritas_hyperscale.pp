# == define: cinder::backend::veritas_hyperscale
#
# Configures Cinder to use the Veritas HyperScale Block Storage driver
#
# === Parameters
#
# [*volume_backend_name*]
#   (optional) The name of the cinder::backend::veritas_hyperscale ressource
#   Defaults to $name.
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend
#   Defaults to: {}
#   Example :
#     { 'veritas_hyperscale_backend/param1' => { 'value' => value1 } }
#
# [*manage_volume_type*]
#   (Optional) Whether or not manage Cinder Volume type.
#   If set to true, a Cinder Volume type will be created
#   with volume_backend_name=$volume_backend_name key/value.
#   Defaults to false.
#
# === Authors
#
# Abhishek Kane <abhishek.kane@veritas.com>
#
# === Copyright
#
# Copyright (c) 2017 Veritas Technologies LLC.
#

define cinder::backend::veritas_hyperscale (
  $volume_backend_name = $name,
  $extra_options       = {},
  $manage_volume_type  = false,
) {

  include ::cinder::deps

  cinder_config {
    "${name}/volume_backend_name":        value => $volume_backend_name;
    "${name}/volume_driver":              value => 'cinder.volume.drivers.veritas.vrtshyperscale.HyperScaleDriver';
    "${name}/image_volume_cache_enabled": value => true
  }

  if $manage_volume_type {
    cinder_type { $name:
      ensure     => present,
      properties => ["volume_backend_name=${name}"],
    }
  }

  create_resources('cinder_config', $extra_options)
}
