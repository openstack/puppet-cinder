#
# == Class: cinder::volume::hds
#
# Configures Cinder to use HNAS as a volume driver
#
# === Parameters
#
# [*hds_hnas_nfs_config_file*]
#   (required) The config file to store HNAS shares info.
#   Defaults to '/etc/cinder/cinder_nfs_conf.xml'
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend stanza
#   Defaults to: {}
#   Example :
#     { 'hds_backend/param1' => { 'value' => value1 } }
#
# === Examples
# cinder_nfs_conf.xml
#
#<?xml version="1.0" encoding="UTF-8" ?>
#
#<config>
#  <mgmt_ip0>172.24.44.15</mgmt_ip0>
#  <username>supervisor</username>
#  <password>supervisor</password>
#  <enable_ssh>True</enable_ssh>
#  <ssh_private_key>/home/user/.ssh/id_rsa</ssh_private_key>
#  <svc_0>
#    <volume_type>default</volume_type>
#    <hdp>172.24.44.26:/default</hdp>
#  </svc_0>
#  <svc_1>
#    <volume_type>gold</volume_type>
#    <hdp>172.24.44.26:/gold</hdp>
#  </svc_1>
#  <svc_2>
#    <volume_type>platinum</volume_type>
#    <hdp>172.24.44.26:/platinum</hdp>
#  </svc_2>
#  <svc_3>
#    <volume_type>silver</volume_type>
#    <hdp>172.24.44.26:/silver</hdp>
#  </svc_3>
#
#</config>
#
# === Copyright
#
# Copyright 2015 Hitachi Data System
#

class cinder:backend::hds (
  $volume_backend_name       = $name,
  $hds_hnas_nfs_config_file    = '/etc/cinder/cinder_nfs_conf.xml',
  $extra_options              = {},
) {

  cinder_config {
    "${name}/hds_hnas_nfs_config_file":  value    => $hds_hnas_nfs_config_file;
  }

 create_resources('cinder_config', $extra_options)

}
