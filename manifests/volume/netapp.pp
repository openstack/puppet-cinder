# == Class: cinder::volume::netapp
#
# Configures Cinder to use the NetApp unified volume driver
#
# === Parameters
#
# [*netapp_login*]
#   (required) Administrative user account name used to access the storage
#   system.
#
# [*netapp_password*]
#   (required) Password for the administrative user account specified in the
#   netapp_login parameter.
#
# [*netapp_server_hostname*]
#   (required) The hostname (or IP address) for the storage system.
#
# [*netapp_server_port*]
#   (optional) The TCP port to use for communication with ONTAPI on the
#   storage system. Traditionally, port 80 is used for HTTP and port 443 is
#   used for HTTPS; however, this value should be changed if an alternate
#   port has been configured on the storage system.
#   Defaults to 80
#
# [*netapp_size_multiplier*]
#   (optional) The quantity to be multiplied by the requested volume size to
#   ensure enough space is available on the virtual storage server (Vserver) to
#   fulfill the volume creation request.
#   Defaults to 1.2
#
# [*netapp_storage_family*]
#   (optional) The storage family type used on the storage system; valid values
#   are ontap_7mode for using Data ONTAP operating in 7-Mode or ontap_cluster
#   for using clustered Data ONTAP.
#   Defaults to ontap_cluster
#
# [*netapp_storage_protocol*]
#   (optional) The storage protocol to be used on the data path with the storage
#   system; valid values are iscsi or nfs.
#   Defaults to nfs
#
# [*netapp_transport_type*]
#   (optional) The transport protocol used when communicating with ONTAPI on the
#   storage system. Valid values are http or https.
#   Defaults to http
#
# [*netapp_vfiler*]
#   (optional) The vFiler unit on which provisioning of block storage volumes
#   will be done. This parameter is only used by the driver when connecting to
#   an instance with a storage family of Data ONTAP operating in 7-Mode and the
#   storage protocol selected is iSCSI. Only use this parameter when utilizing
#   the MultiStore feature on the NetApp storage system.
#   Defaults to ''
#
# [*netapp_volume_list*]
#   (optional) This parameter is only utilized when the storage protocol is
#   configured to use iSCSI. This parameter is used to restrict provisioning to
#   the specified controller volumes. Specify the value of this parameter to be
#   a comma separated list of NetApp controller volume names to be used for
#   provisioning.
#   Defaults to ''
#
# [*netapp_vserver*]
#   (optional) This parameter specifies the virtual storage server (Vserver)
#   name on the storage cluster on which provisioning of block storage volumes
#   should occur. If using the NFS storage protocol, this parameter is mandatory
#   for storage service catalog support (utilized by Cinder volume type
#   extra_specs support). If this parameter is specified, the exports belonging
#   to the Vserver will only be used for provisioning in the future. Block
#   storage volumes on exports not belonging to the Vserver specified by
#   this parameter will continue to function normally.
#   Defaults to ''
#
# [*expiry_thres_minutes*]
#   (optional) This parameter specifies the threshold for last access time for
#   images in the NFS image cache. When a cache cleaning cycle begins, images
#   in the cache that have not been accessed in the last M minutes, where M is
#   the value of this parameter, will be deleted from the cache to create free
#   space on the NFS share.
#   Defaults to 720
#
# [*thres_avl_size_perc_start*]
#   (optional) If the percentage of available space for an NFS share has
#   dropped below the value specified by this parameter, the NFS image cache
#   will be cleaned.
#   Defaults to 20
#
# [*thres_avl_size_perc_stop*]
#   (optional) When the percentage of available space on an NFS share has reached the
#   percentage specified by this parameter, the driver will stop clearing files
#   from the NFS image cache that have not been accessed in the last M
#   'minutes, where M is the value of the expiry_thres_minutes parameter.
#   Defaults to 60
#
# === Examples
#
#  class { 'cinder::volume::netapp':
#    netapp_login => 'clusterAdmin',
#    netapp_password => 'password',
#    netapp_server_hostname => 'netapp.mycorp.com',
#    netapp_server_port => '443',
#    netapp_transport_type => 'https',
#    netapp_vserver => 'openstack-vserver',
#  }
#
# === Authors
#
# Bob Callaway <bob.callaway@netapp.com>
#
# === Copyright
#
# Copyright 2013 NetApp, Inc.
#
class cinder::volume::netapp (
  $netapp_login,
  $netapp_password,
  $netapp_server_hostname,
  $netapp_server_port        = '80',
  $netapp_size_multiplier    = '1.2',
  $netapp_storage_family     = 'ontap_cluster',
  $netapp_storage_protocol   = 'nfs',
  $netapp_transport_type     = 'http',
  $netapp_vfiler             = '',
  $netapp_volume_list        = '',
  $netapp_vserver            = '',
  $expiry_thres_minutes      = '720',
  $thres_avl_size_perc_start = '20',
  $thres_avl_size_perc_stop  = '60'
) {

  cinder_config {
    'DEFAULT/volume_driver':                 value => 'cinder.volume.drivers.netapp.common.NetAppDriver';
    'DEFAULT/netapp_login':                  value => $netapp_login;
    'DEFAULT/netapp_password':               value => $netapp_password, secret => true;
    'DEFAULT/netapp_server_hostname':        value => $netapp_server_hostname;
    'DEFAULT/netapp_server_port':            value => $netapp_server_port;
    'DEFAULT/netapp_size_multiplier':        value => $netapp_size_multiplier;
    'DEFAULT/netapp_storage_family':         value => $netapp_storage_family;
    'DEFAULT/netapp_storage_protocol':       value => $netapp_storage_protocol;
    'DEFAULT/netapp_transport_type':         value => $netapp_transport_type;
    'DEFAULT/netapp_vfiler':                 value => $netapp_vfiler;
    'DEFAULT/netapp_volume_list':            value => $netapp_volume_list;
    'DEFAULT/netapp_vserver':                value => $netapp_vserver;
    'DEFAULT/expiry_thres_minutes':          value => $expiry_thres_minutes;
    'DEFAULT/thres_avl_size_perc_start':     value => $thres_avl_size_perc_start;
    'DEFAULT/thres_avl_size_perc_stop':      value => $thres_avl_size_perc_stop;
  }

}
