#
# Class to execute cinder dbsync
#
# == Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the cinder-manage db sync command. These will be inserted
#   in the command line between 'cinder-manage' and 'db sync'.
#   Defaults to undef
#
class cinder::db::sync(
  $extra_params = undef,
) {

  include ::cinder::deps
  include ::cinder::params

  exec { 'cinder-manage db_sync':
    command     => "cinder-manage ${extra_params} db sync",
    path        => '/usr/bin',
    user        => 'cinder',
    refreshonly => true,
    logoutput   => 'on_failure',
    subscribe   => [
      Anchor['cinder::install::end'],
      Anchor['cinder::config::end'],
      Anchor['cinder::dbsync::begin']
    ],
    notify      => Anchor['cinder::dbsync::end'],
  }
}
