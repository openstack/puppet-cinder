# == define: cinder::backend::netapp
#
# Configures Cinder to use the NetApp unified volume driver
# Compatible for multiple backends
#
# === Parameters
#
# [*netapp_login*]
#   (required) Administrative user account name used to access the storage
#   system or proxy server.
#
# [*netapp_password*]
#   (required) Password for the administrative user account specified in the
#   netapp_login option.
#
# [*netapp_server_hostname*]
#   (required) The hostname (or IP address) for the storage system or proxy
#   server.
#
# [*volume_backend_name*]
#   (optional) The name of the cinder::backend::netapp resource
#   Defaults to $name.
#
# [*backend_availability_zone*]
#   (Optional) Availability zone for this volume backend.
#   If not set, the storage_availability_zone option value
#   is used as the default for all backends.
#   Defaults to $facts['os_service_default'].
#
# [*reserved_percentage*]
#   (Optional) The percentage of backend capacity is reserved.
#   Defaults to $facts['os_service_default'].
#
# [*netapp_server_port*]
#   (optional) The TCP port to use for communication with the storage
#   system or proxy. If not specified, Data ONTAP drivers will use 80
#   for HTTP and 443 for HTTPS;
#   Defaults to $facts['os_service_default'].
#
# [*netapp_size_multiplier*]
#   (optional) The quantity to be multiplied by the requested volume size to
#   ensure enough space is available on the virtual storage server (Vserver) to
#   fulfill the volume creation request.
#   Defaults to $facts['os_service_default'].
#
# [*netapp_storage_family*]
#   (optional) The storage family type used on the storage system; valid value
#   is ontap_cluster for using clustered Data ONTAP.
#   Defaults to $facts['os_service_default'].
#
# [*netapp_storage_protocol*]
#   (optional) The storage protocol to be used on the data path with the storage
#   system. Valid values are iscsi, fc, nfs.
#   Defaults to nfs
#
# [*netapp_transport_type*]
#   (optional) The transport protocol used when communicating with the storage
#   system or proxy server. Valid values are http or https.
#   Defaults to $facts['os_service_default'].
#
# [*netapp_vserver*]
#   (optional) This option specifies the virtual storage server (Vserver)
#   name on the storage cluster on which provisioning of block storage volumes
#   should occur.
#   Defaults to $facts['os_service_default'].
#
# [*expiry_thres_minutes*]
#   (optional) This parameter specifies the threshold for last access time for
#   images in the NFS image cache. When a cache cleaning cycle begins, images
#   in the cache that have not been accessed in the last M minutes, where M is
#   the value of this parameter, will be deleted from the cache to create free
#   space on the NFS share.
#   Defaults to $facts['os_service_default'].
#
# [*thres_avl_size_perc_start*]
#   (optional) If the percentage of available space for an NFS share has
#   dropped below the value specified by this parameter, the NFS image cache
#   will be cleaned.
#   Defaults to $facts['os_service_default'].
#
# [*thres_avl_size_perc_stop*]
#   (optional) When the percentage of available space on an NFS share has
#   reached the percentage specified by this parameter, the driver will stop
#   clearing files from the NFS image cache that have not been accessed in the
#   last M minutes, where M is the value of the expiry_thres_minutes parameter.
#   Defaults to $facts['os_service_default'].
#
# [*nfs_shares*]
#   (optional) Array of NFS exports in the form of host:/share; will be written into
#    file specified in nfs_shares_config
#    Defaults to undef
#
# [*nfs_shares_config*]
#   (optional) File with the list of available NFS shares
#   Defaults to '/etc/cinder/shares.conf'
#
# [*nfs_mount_options*]
#   (optional) Mount options passed to the nfs client. See section
#   of the nfs man page for details.
#   Defaults to $facts['os_service_default']
#
# [*netapp_pool_name_search_pattern*]
#   (optional) This option is only utilized when the Cinder driver is
#   configured to use iSCSI or Fibre Channel. It is used to restrict
#   provisioning to the specified FlexVol volumes. Specify the value of this
#   option as a regular expression which will be applied to the names of
#   FlexVol volumes from the storage backend which represent pools in Cinder.
#   ^ (beginning of string) and $ (end of string) are implicitly wrapped around
#   the regular expression specified before filtering.
#   Defaults to $facts['os_service_default'].
#
# [*netapp_host_type*]
#   (optional) This option is used to define how the controllers will work with
#   the particular operating system on the hosts that are connected to it.
#   Defaults to $facts['os_service_default']
#
# [*nas_secure_file_operations*]
#   (Optional) Allow network-attached storage systems to operate in a secure
#   environment where root level access is not permitted. If set to False,
#   access is as the root user and insecure. If set to True, access is not as
#   root. If set to auto, a check is done to determine if this is a new
#   installation: True is used if so, otherwise False. Default is auto.
#   Defaults to $facts['os_service_default']
#
# [*nas_secure_file_permissions*]
#   (Optional) Set more secure file permissions on network-attached storage
#   volume files to restrict broad other/world access. If set to False,
#   volumes are created with open permissions. If set to True, volumes are
#   created with permissions for the cinder user and group (660). If set to
#   auto, a check is done to determine if this is a new installation: True is
#   used if so, otherwise False. Default is auto.
#   Defaults to $facts['os_service_default']
#
# [*manage_volume_type*]
#   (Optional) Whether or not manage Cinder Volume type.
#   If set to true, a Cinder Volume type will be created
#   with volume_backend_name=$volume_backend_name key/value.
#   Defaults to false.
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend stanza
#   Defaults to: {}
#   Example :
#     { 'netapp_backend/param1' => { 'value' => value1 } }
#
# DEPRECATED PARAMETERS
#
# [*netapp_copyoffload_tool_path*]
#   (optional) This option specifies the path of the NetApp Copy Offload tool
#   binary. Ensure that the binary has execute permissions set which allow the
#   effective user of the cinder-volume process to execute the file.
#   Defaults to undef
#
# === Examples
#
#  cinder::backend::netapp { 'myBackend':
#    netapp_login           => 'clusterAdmin',
#    netapp_password        => 'password',
#    netapp_server_hostname => 'netapp.mycorp.com',
#    netapp_server_port     => '443',
#    netapp_transport_type  => 'https',
#    netapp_vserver         => 'openstack-vserver',
#  }
#
# === Authors
#
# Bob Callaway <bob.callaway@netapp.com>
#
# === Copyright
#
# Copyright 2014 NetApp, Inc.
#
define cinder::backend::netapp (
  $netapp_login,
  $netapp_password,
  $netapp_server_hostname,
  $volume_backend_name                    = $name,
  $backend_availability_zone              = $facts['os_service_default'],
  $reserved_percentage                    = $facts['os_service_default'],
  $netapp_server_port                     = $facts['os_service_default'],
  $netapp_size_multiplier                 = $facts['os_service_default'],
  $netapp_storage_family                  = $facts['os_service_default'],
  $netapp_storage_protocol                = 'nfs',
  $netapp_transport_type                  = $facts['os_service_default'],
  $netapp_vserver                         = $facts['os_service_default'],
  $expiry_thres_minutes                   = $facts['os_service_default'],
  $thres_avl_size_perc_start              = $facts['os_service_default'],
  $thres_avl_size_perc_stop               = $facts['os_service_default'],
  Optional[Array[String]] $nfs_shares     = undef,
  Stdlib::Absolutepath $nfs_shares_config = '/etc/cinder/shares.conf',
  $nfs_mount_options                      = $facts['os_service_default'],
  $netapp_host_type                       = $facts['os_service_default'],
  Boolean $manage_volume_type             = false,
  Hash $extra_options                     = {},
  $netapp_pool_name_search_pattern        = $facts['os_service_default'],
  $nas_secure_file_operations             = $facts['os_service_default'],
  $nas_secure_file_permissions            = $facts['os_service_default'],
  # DEPRECATED PARAMETERS
  $netapp_copyoffload_tool_path           = undef,
) {

  include cinder::deps

  if $netapp_copyoffload_tool_path != undef {
    warning("The netapp_copyoffload_tool_path parameter has been deprecated \
and will be removed in a future release.")
  }

  if $nfs_shares {
    file {$nfs_shares_config:
      content => join($nfs_shares, "\n"),
      require => Anchor['cinder::install::end'],
      notify  => Anchor['cinder::service::begin'],
    }
  }

  cinder_config {
    "${name}/nfs_mount_options":                value => $nfs_mount_options;
    "${name}/volume_backend_name":              value => $volume_backend_name;
    "${name}/backend_availability_zone":        value => $backend_availability_zone;
    "${name}/reserved_percentage":              value => $reserved_percentage;
    "${name}/volume_driver":                    value => 'cinder.volume.drivers.netapp.common.NetAppDriver';
    "${name}/netapp_login":                     value => $netapp_login;
    "${name}/netapp_password":                  value => $netapp_password, secret => true;
    "${name}/netapp_server_hostname":           value => $netapp_server_hostname;
    "${name}/netapp_server_port":               value => $netapp_server_port;
    "${name}/netapp_size_multiplier":           value => $netapp_size_multiplier;
    "${name}/netapp_storage_family":            value => $netapp_storage_family;
    "${name}/netapp_storage_protocol":          value => $netapp_storage_protocol;
    "${name}/netapp_transport_type":            value => $netapp_transport_type;
    "${name}/netapp_vserver":                   value => $netapp_vserver;
    "${name}/expiry_thres_minutes":             value => $expiry_thres_minutes;
    "${name}/thres_avl_size_perc_start":        value => $thres_avl_size_perc_start;
    "${name}/thres_avl_size_perc_stop":         value => $thres_avl_size_perc_stop;
    "${name}/nfs_shares_config":                value => $nfs_shares_config;
    "${name}/netapp_copyoffload_tool_path":     value => pick($netapp_copyoffload_tool_path, $facts['os_service_default']);
    "${name}/netapp_pool_name_search_pattern":  value => $netapp_pool_name_search_pattern;
    "${name}/netapp_host_type":                 value => $netapp_host_type;
    "${name}/nas_secure_file_operations":       value => $nas_secure_file_operations;
    "${name}/nas_secure_file_permissions":      value => $nas_secure_file_permissions;
  }

  if $manage_volume_type {
    cinder_type { $name:
      ensure     => present,
      properties => ["volume_backend_name=${name}"],
    }
  }

  create_resources('cinder_config', $extra_options)

}
