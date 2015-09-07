# == Class: cinder::logging
#
#  Cinder extended logging configuration
#
# === Parameters
#
#  [*logging_context_format_string*]
#    (Optional) Format string to use for log messages with context.
#    Defaults to '<SERVICE DEFAULT>'
#    Example: '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s\
#              [%(request_id)s %(user_identity)s] %(instance)s%(message)s'
#
#  [*logging_default_format_string*]
#    (Optional) Format string to use for log messages without context.
#    Defaults to '<SERVICE DEFAULT>'
#    Example: '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s\
#              [-] %(instance)s%(message)s'
#
#  [*logging_debug_format_suffix*]
#    (Optional) Formatted data to append to log format when level is DEBUG.
#    Defaults to '<SERVICE DEFAULT>'
#    Example: '%(funcName)s %(pathname)s:%(lineno)d'
#
#  [*logging_exception_prefix*]
#    (Optional) Prefix each line of exception output with this format.
#    Defaults to '<SERVICE DEFAULT>'
#    Example: '%(asctime)s.%(msecs)03d %(process)d TRACE %(name)s %(instance)s'
#
#  [*log_config_append*]
#    The name of an additional logging configuration file.
#    Defaults to '<SERVICE DEFAULT>'
#    See https://docs.python.org/2/howto/logging.html
#
#  [*default_log_levels*]
#    (optional) Hash of logger (keys) and level (values) pairs.
#    Defaults to undef.
#    Example:
#      { 'amqp' => 'WARN', 'amqplib' => 'WARN', 'boto' => 'WARN',
#        'qpid' => 'WARN', 'sqlalchemy' => 'WARN', 'suds' => 'INFO',
#        'iso8601' => 'WARN',
#        'requests.packages.urllib3.connectionpool' => 'WARN' }
#
#  [*publish_errors*]
#    (optional) Publish error events (boolean value).
#    Defaults to '<SERVICE DEFAULT>'
#
#  [*fatal_deprecations*]
#    (optional) Make deprecations fatal (boolean value)
#    Defaults to '<SERVICE DEFAULT>'
#
#  [*instance_format*]
#    (optional) If an instance is passed with the log message, format it
#               like this (string value).
#    Defaults to '<SERVICE DEFAULT>'
#    Example: '[instance: %(uuid)s] '
#
#  [*instance_uuid_format*]
#    (optional) If an instance UUID is passed with the log message, format
#               it like this (string value).
#    Defaults to '<SERVICE DEFAULT>'
#    Example: instance_uuid_format='[instance: %(uuid)s] '
#
#  [*log_date_format*]
#    (optional) Format string for %%(asctime)s in log records.
#    Defaults to '<SERVICE DEFAULT>'
#    Example: 'Y-%m-%d %H:%M:%S'
#
class cinder::logging(
  $logging_context_format_string = '<SERVICE DEFAULT>',
  $logging_default_format_string = '<SERVICE DEFAULT>',
  $logging_debug_format_suffix   = '<SERVICE DEFAULT>',
  $logging_exception_prefix      = '<SERVICE DEFAULT>',
  $log_config_append             = '<SERVICE DEFAULT>',
  $default_log_levels            = undef,
  $publish_errors                = '<SERVICE DEFAULT>',
  $fatal_deprecations            = '<SERVICE DEFAULT>',
  $instance_format               = '<SERVICE DEFAULT>',
  $instance_uuid_format          = '<SERVICE DEFAULT>',
  $log_date_format               = '<SERVICE DEFAULT>',
) {

  cinder_config {
    'DEFAULT/logging_context_format_string' : value => $logging_context_format_string;
    'DEFAULT/logging_default_format_string' : value => $logging_default_format_string;
    'DEFAULT/logging_debug_format_suffix' :   value => $logging_debug_format_suffix;
    'DEFAULT/logging_exception_prefix' :      value => $logging_exception_prefix;
    'DEFAULT/log_config_append' :             value => $log_config_append;
    'DEFAULT/publish_errors' :                value => $publish_errors;
    'DEFAULT/fatal_deprecations' :            value => $fatal_deprecations;
    'DEFAULT/instance_format' :               value => $instance_format;
    'DEFAULT/instance_uuid_format' :          value => $instance_uuid_format;
    'DEFAULT/log_date_format' :               value => $log_date_format;
  }

  if $default_log_levels {
    cinder_config {
      'DEFAULT/default_log_levels' :
        value => join(sort(join_keys_to_values($default_log_levels, '=')), ',');
    }
  } else {
    cinder_config {
      'DEFAULT/default_log_levels' : ensure => absent;
    }
  }

}
