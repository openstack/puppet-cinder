# == Class: cinder::ceilometer
#
# DEPRECATED!
# Setup Cinder to enable ceilometer can retrieve volume samples
#
# === Parameters
#
# [*notification_transport_url*]
#   (Optional) A URL representing the messaging driver to use for notifications
#   and its full configuration. Transport URLs take the form:
#     transport://user:pass@host1:port[,hostN:portN]/virtual_host
#   Defaults to undef
#
# [*notification_driver*]
#   (Option) Driver or drivers to handle sending notifications.
#   Defaults to undef
#
# [*notification_topics*]
#   (Optional) AMQP topic used for OpenStack notifications
#   Defaults to undef
#
class cinder::ceilometer (
  $notification_transport_url = undef,
  $notification_driver        = undef,
  $notification_topics        = undef,
) {

  warning('cinder::ceilometer is deprecated and has no effect')
}
