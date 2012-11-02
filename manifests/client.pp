class cinder::client(
  $package_ensure = 'present'
) {
  package { 'python-cinderclient':
    ensure => $package_ensure,
  }
}
