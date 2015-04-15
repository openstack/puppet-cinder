#
# == Class: cinder::volume::hnas
#
# Configures Cinder to use HNAS as a volume driver
#
# === Parameters
#
# [*hds_hnas_iscsi_config_file*]
#   (required) The config file to store HNAS iscsi info.
#   Defaults to '/etc/cinder/cinder_iscsi_conf.xml'
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend stanza
#   Defaults to: {}
#   Example :
#     { 'hnas_backend/param1' => { 'value' => value1 } }
#
# === Examples
# cinder_iscsi_conf.xml
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
#    <iscsi_ip>172.24.44.26</iscsi_ip>
#    <hdp>dev-default</hdp>
#  </svc_0>
#  <svc_1>
#    <volume_type>gold</volume_type>
#    <iscsi_ip>172.24.44.26</iscsi_ip>
#    <hdp>dev-gold</hdp>
#  </svc_1>
#  <svc_2>
#    <volume_type>platinum</volume_type>
#    <iscsi_ip>172.24.44.26</iscsi_ip>
#    <hdp>dev-platinum</hdp>
#  </svc_2>
#  <svc_3>
#    <volume_type>silver</volume_type>
#    <iscsi_ip>172.24.44.26</iscsi_ip>
#    <hdp>dev-silver</hdp>
#  </svc_3>
#</config>
#
# === Copyright
#
# Copyright 2015 Hitachi Data System
#

class cinder::volume::hnas (
  $hds_hnas_iscsi_config_file    = '/etc/cinder/cinder_iscsi_conf.xml',
  $extra_options              = {},
) {

  cinder::backend::hnas { 'DEFAULT':
    hds_hnas_iscsi_config_file    => $hds_hnas_iscsi_config_file,
    extra_options              => $extra_options,
  }
}
