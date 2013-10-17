# == Class: cinder::ceilometer
#
# Setup Cinder to enable ceilometer can retrieve volume samples
# Ref: http://docs.openstack.org/developer/ceilometer/install/manual.html
#
# === Parameters
#
# [*notification_driver*]
#   (option) Driver or drivers to handle sending notifications.
#    Notice: rabbit_notifier has been deprecated in Grizzly, use rpc_notifier instead.
# [*control_exchange*]
#   (option) AMQP exchange to connect to if using RabbitMQ or Qpid.
#


class cinder::ceilometer (
  $notification_driver = 'cinder.openstack.common.notifier.rpc_notifier',
  $control_exchange    = 'cinder'
) {

  cinder_config {
    'DEFAULT/notification_driver':     value => $notification_driver;
    'DEFAULT/control_exchange':        value => $control_exchange;
  }
}

