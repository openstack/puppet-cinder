# == Class: cinder::ceilometer
#
# Setup Cinder to enable ceilometer can retrieve volume samples
#
# === Parameters
#
# [*notification_transport_url*]
#   (Optional) A URL representing the messaging driver to use for notifications
#   and its full configuration. Transport URLs take the form:
#     transport://user:pass@host1:port[,hostN:portN]/virtual_host
#   Defaults to $::os_service_default
#
# [*notification_driver*]
#   (Option) Driver or drivers to handle sending notifications.
#   Defaults to 'messagingv2'
#
# [*notification_topics*]
#   (Optional) AMQP topic used for OpenStack notifications
#   Defaults to $::os_service_default
#
class cinder::ceilometer (
  $notification_transport_url = $::os_service_default,
  $notification_driver        = 'messagingv2',
  $notification_topics        = $::os_service_default,
) {

  include ::cinder::deps

  oslo::messaging::notifications { 'cinder_config':
    transport_url => $notification_transport_url,
    driver        => $notification_driver,
    topics        => $notification_topics,
  }
}
