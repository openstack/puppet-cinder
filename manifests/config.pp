# == Class: cinder::config
#
# This class is used to manage arbitrary cinder configurations.
#
# example xxx_config
#   (optional) Allow configuration of arbitrary cinder configurations.
#   The value is a hash of xxx_config resources. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#
#   In yaml format, Example:
#   xxx_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
# === Parameters
#
# [*cinder_config*]
#   (optional) Allow configuration of cinder.conf configurations.
#   Defaults to empty hash'{}'
#
# [*api_paste_ini_config*]
#   (optional) Allow configuration of api-paste.ini configurations.
#
# [*cinder_rootwrap_config*]
#   (optional) Allow configuration of rootwrap.conf configurations.
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class cinder::config (
  Hash $cinder_config          = {},
  Hash $api_paste_ini_config   = {},
  Hash $cinder_rootwrap_config = {},
) {
  include cinder::deps

  create_resources('cinder_config', $cinder_config)
  create_resources('cinder_api_paste_ini', $api_paste_ini_config)
  create_resources('cinder_rootwrap_config', $cinder_rootwrap_config)
}
