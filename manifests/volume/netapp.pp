#
class cinder::volume::netapp (
  $netapp_wsdl_url,
  $netapp_login,
  $netapp_password,
  $netapp_server_hostname,
  $netapp_storage_service,
  $netapp_server_port            = '8088',
  $netapp_storage_service_prefix = 'openstack',
  $netapp_vfiler                 = undef
) {

  include cinder::params

  cinder_config {
    'DEFAULT/volume_driver':                 value => 'cinder.volume.netapp.NetAppISCSIDriver';
    'DEFAULT/netapp_wsdl_url':               value => $netapp_wsdl_url;
    'DEFAULT/netapp_login':                  value => $netapp_login;
    'DEFAULT/netapp_password':               value => $netapp_password;
    'DEFAULT/netapp_server_hostname':        value => $netapp_server_hostname;
    'DEFAULT/netapp_storage_service':        value => $netapp_storage_service;
    'DEFAULT/netapp_server_port':            value => $netapp_server_port;
    'DEFAULT/netapp_storage_service_prefix': value => $netapp_storage_service_prefix;
    'DEFAULT/netapp_vfiler':                 value => $netapp_vfiler;
  }

}
