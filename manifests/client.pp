# == Class: cinder::client
#
# Installs Cinder python client.
#
# === Parameters
#
# [*package_ensure*]
#   (Optional) Ensure state for package.
#   Defaults to 'present'.
#
class cinder::client(
  $package_ensure = 'present'
) {

  include ::cinder::deps
  include ::cinder::params

  package { 'python-cinderclient':
    ensure => $package_ensure,
    name   => $::cinder::params::client_package,
    tag    => ['openstack', 'cinder-support-package'],
  }

  include '::openstacklib::openstackclient'
}
