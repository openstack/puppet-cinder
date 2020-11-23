#
# Class to execute cinder dbsync
#
# == Parameters
#
# [*extra_params*]
#   (Optional) String of extra command line parameters to append
#   to the cinder-manage db sync command. These will be inserted
#   in the command line between 'cinder-manage' and 'db sync'.
#   Defaults to undef
#
# [*db_sync_timeout*]
#   (Optional) Timeout for the execution of the db_sync
#   Defaults to 300
#
class cinder::db::sync(
  $extra_params    = undef,
  $db_sync_timeout = 300,
) {

  include cinder::deps

  exec { 'cinder-manage db_sync':
    command     => "cinder-manage ${extra_params} db sync",
    path        => ['/bin', '/usr/bin'],
    user        => 'cinder',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    timeout     => $db_sync_timeout,
    logoutput   => 'on_failure',
    subscribe   => [
      Anchor['cinder::install::end'],
      Anchor['cinder::config::end'],
      Anchor['cinder::dbsync::begin']
    ],
    notify      => Anchor['cinder::dbsync::end'],
    tag         => 'openstack-db',
  }
}
