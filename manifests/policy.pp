# == Class: cinder::policy
#
# Configure the cinder policies
#
# === Parameters
#
# [*policies*]
#   (optional) Set of policies to configure for cinder
#   Example :
#     {
#       'cinder-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       'cinder-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (optional) Path to the cinder policy.json file
#   Defaults to /etc/cinder/policy.json
#
class cinder::policy (
  $policies    = {},
  $policy_path = '/etc/cinder/policy.json',
) {

  include ::cinder::deps
  include ::cinder::params

  validate_hash($policies)

  Openstacklib::Policy::Base {
    file_path  => $policy_path,
    file_user  => 'root',
    file_group => $::cinder::params::group,
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'cinder_config': policy_file => $policy_path }

}
