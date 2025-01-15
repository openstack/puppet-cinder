# == Class: cinder:scheduler::filter
#
# This class is aim to configure cinder.scheduler filter
#
# === Parameters:
#
# [*default_filters*]
#   (Optional) List of filter class names to use for filtering hosts.
#   Defaults to $facts['os_service_default']
#
# [*default_weighers*]
#   (Optional) List of weigher class names to use for weighning hosts.
#   Defaults to $facts['os_service_default']
#
# [*weight_handler*]
#   (Optional) Handler to use for selecting the host/pool after weighing.
#   Defaults to $facts['os_service_default']
#
# [*capacity_weight_multiplier*]
#   (Optional) Multiplier used for weighing free capacity.
#   Defaults to $facts['os_service_default']
#
# [*allocated_capacity_weight_multiplier*]
#   (Optional) Multiplier used for weighing allocated capacity.
#   Defaults to $facts['os_service_default']
#
# [*volume_number_multiplier*]
#   (Optional) Multiplier used for weighing volume number..
#   Defaults to $facts['os_service_default']
#
# DEPRECATED PARAMETERS
#
# [*scheduler_default_filters*]
#   (Optional) List of filter class names to use for filtering hosts.
#   Defaults to $facts['os_service_default']
#
class cinder::scheduler::filter (
  $default_filters                      = $facts['os_service_default'],
  $default_weighers                     = $facts['os_service_default'],
  $weight_handler                       = $facts['os_service_default'],
  $capacity_weight_multiplier           = $facts['os_service_default'],
  $allocated_capacity_weight_multiplier = $facts['os_service_default'],
  $volume_number_multiplier             = $facts['os_service_default'],
  # DEPRECATED PARAMETERS
  $scheduler_default_filters            = undef,
) {

  include cinder::deps

  if $scheduler_default_filters != undef {
    warning("The scheduler_default_filters parameter has been deprecated. \
Use the default_filters parameter instead")
    $default_filters_real = $scheduler_default_filters
  } else {
    $default_filters_real = $default_filters
  }

  cinder_config {
    'DEFAULT/scheduler_default_filters':
      value => join(any2array($default_filters_real),',');
    'DEFAULT/scheduler_default_weighers':
      value => join(any2array($default_weighers),',');
    'DEFAULT/scheduler_weight_handler':
      value => $weight_handler;
    'DEFAULT/capacity_weight_multiplier':
      value => $capacity_weight_multiplier;
    'DEFAULT/allocated_capacity_weight_multiplier':
      value => $allocated_capacity_weight_multiplier;
    'DEFAULT/volume_number_multiplier':
      value => $volume_number_multiplier;
  }
}
