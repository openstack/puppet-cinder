class cinder::client(
  $package_ensure = 'present'
) {
  package { 'python-cinderclient':
    name   => $::cinder::params::client_package,
    ensure => $package_ensure,
  }
}
