# == Class: cinder:scheduler::filter
#
# This class is aim to configure cinder.scheduler filter
#
# === Parameters:
#
# [*scheduler_default_filters*]
#   A comma separated list of filters to be used by default
#   Defaults to $::os_service_default

class cinder::scheduler::filter (
  $scheduler_default_filters = $::os_service_default,
) {

  include ::cinder::deps

  if (!is_service_default($scheduler_default_filters)) {
    cinder_config {
      'DEFAULT/scheduler_default_filters': value  => join(any2array($scheduler_default_filters),',')
    }
  } else {
    cinder_config {
      'DEFAULT/scheduler_default_filters': ensure => absent
    }
  }

}
