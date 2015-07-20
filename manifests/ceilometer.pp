# == Class: cinder::ceilometer
#
# Setup Cinder to enable ceilometer can retrieve volume samples
# Ref: http://docs.openstack.org/developer/ceilometer/install/manual.html
#
# === Parameters
#
# [*notification_driver*]
#   (option) Driver or drivers to handle sending notifications.
#   The default value of 'messagingv2' is for enabling notifications via
#   oslo.messaging.  'cinder.openstack.common.notifier.rpc_notifier' is the
#   backwards compatible option that will be deprecated. Prior to Grizzly,
#   'cinder.openstack.common.notifier.rabbit_notifier' was used. oslo.messaging
#   was adopted in icehouse/juno. See LP#1425713.
#
class cinder::ceilometer (
  $notification_driver = 'messagingv2',
) {

  cinder_config {
    'DEFAULT/notification_driver': value => $notification_driver;
  }
}
