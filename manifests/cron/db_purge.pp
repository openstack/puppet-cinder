#
# Copyright (C) 2015 Red Hat Inc.
#
# Author: Martin Magr <mmagr@redhat.com>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# == Class: cinder::cron::db_purge
#
# Move deleted instances to another table that you don't have to backup
# unless you have data retention policies.
#
# === Parameters
#
#  [*minute*]
#    (optional) Defaults to '1'.
#
#  [*hour*]
#    (optional) Defaults to '0'.
#
#  [*monthday*]
#    (optional) Defaults to '*'.
#
#  [*month*]
#    (optional) Defaults to '*'.
#
#  [*weekday*]
#    (optional) Defaults to '*'.
#
#  [*user*]
#    (optional) User with access to cinder files.
#    Defaults to 'cinder'.
#
#  [*age*]
#    (optional) Number of days prior to today for deletion,
#    e.g. value 60 means to purge deleted rows that have the "deleted_at"
#    column greater than 60 days ago.
#    Defaults to 30
#
#  [*destination*]
#    (optional) Path to file to which rows should be archived
#    Defaults to '/var/log/cinder/cinder-rowsflush.log'.
#
class cinder::cron::db_purge (
  $minute      = 1,
  $hour        = 0,
  $monthday    = '*',
  $month       = '*',
  $weekday     = '*',
  $user        = 'cinder',
  $age         = 30,
  $destination = '/var/log/cinder/cinder-rowsflush.log'
) {

  include ::cinder::deps

  cron { 'cinder-manage db purge':
    command     => "cinder-manage db purge ${age} >>${destination} 2>&1",
    environment => 'PATH=/bin:/usr/bin:/usr/sbin SHELL=/bin/sh',
    user        => $user,
    minute      => $minute,
    hour        => $hour,
    monthday    => $monthday,
    month       => $month,
    weekday     => $weekday,
    require     => Anchor['cinder::install::end'],
  }
}
