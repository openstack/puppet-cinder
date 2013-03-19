class cinder::client(
  $package_ensure = 'present'
) {

  include cinder::params

  package { 'python-cinderclient':
    name   => $::cinder::params::client_package,
    ensure => $package_ensure,
  }
}
