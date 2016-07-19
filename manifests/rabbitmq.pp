# == Class: cinder::rabbitmq
#
# Installs and manages rabbitmq server for cinder
#
# == Parameters:
#
# [*userid*]
#   (optional) The username to use when connecting to Rabbit
#   Defaults to 'guest'
#
# [*password*]
#   (optional) The password to use when connecting to Rabbit
#   Defaults to 'guest'
#
# [*port*]
#   (optional) Deprecated. The port to use when connecting to Rabbit
#   This parameter keeps backward compatibility when we used to manage
#   RabbitMQ service.
#   Defaults to '5672'
#
# [*virtual_host*]
#   (optional) The virtual host to use when connecting to Rabbit
#   Defaults to '/'
#
class cinder::rabbitmq(
  $userid         = 'guest',
  $password       = 'guest',
  $virtual_host   = '/',
) {

  include ::cinder::deps

  warning('cinder::rabbitmq class is deprecated and will be removed in next release. Make other plans to configure rabbitmq resources.')

  if $userid == 'guest' {
    $delete_guest_user = false
  } else {
    $delete_guest_user = true
    rabbitmq_user { $userid:
      admin    => true,
      password => $password,
      provider => 'rabbitmqctl',
    }
    # I need to figure out the appropriate permissions
    rabbitmq_user_permissions { "${userid}@${virtual_host}":
      configure_permission => '.*',
      write_permission     => '.*',
      read_permission      => '.*',
      provider             => 'rabbitmqctl',
    } -> Anchor['cinder::service::begin']
  }
  rabbitmq_vhost { $virtual_host:
    provider => 'rabbitmqctl',
  }
}
