# == Class: cinder:scheduler::filter
#
# This class is aim to configure cinder.scheduler filter
#
# === Parameters:
#
# [*scheduler_default_filters*]
#   (Optional) A comma separated list of filters to be used by default
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
class cinder::scheduler::filter (
  $scheduler_default_filters            = $facts['os_service_default'],
  $capacity_weight_multiplier           = $facts['os_service_default'],
  $allocated_capacity_weight_multiplier = $facts['os_service_default'],
  $volume_number_multiplier             = $facts['os_service_default'],
) {

  include cinder::deps

  cinder_config {
    'DEFAULT/scheduler_default_filters':
      value => join(any2array($scheduler_default_filters),',');
    'DEFAULT/capacity_weight_multiplier':
      value => $capacity_weight_multiplier;
    'DEFAULT/allocated_capacity_weight_multiplier':
      value => $allocated_capacity_weight_multiplier;
    'DEFAULT/volume_number_multiplier':
      value => $volume_number_multiplier;
  }
}
