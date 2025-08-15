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
# Remove deleted records from database
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
#    Defaults to $cinder::params::user.
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
#  [*maxdelay*]
#    (optional) In Seconds. Should be a positive integer.
#    Induces a random delay before running the cronjob to avoid running
#    all cron jobs at the same time on all hosts this job is configured.
#    Defaults to 0.
#
#  [*ensure*]
#    (optional) Ensure cron jobs present or absent
#    Defaults to present.
#
class cinder::cron::db_purge (
  $minute                           = 1,
  $hour                             = 0,
  $monthday                         = '*',
  $month                            = '*',
  $weekday                          = '*',
  $user                             = $cinder::params::user,
  $age                              = 30,
  $destination                      = '/var/log/cinder/cinder-rowsflush.log',
  Integer[0] $maxdelay              = 0,
  Enum['present', 'absent'] $ensure = 'present',
) inherits cinder::params {

  include cinder::deps

  if $maxdelay == 0 {
    $sleep = ''
  } else {
    $sleep = "sleep `expr \${RANDOM} \\% ${maxdelay}`; "
  }

  cron { 'cinder-manage db purge':
    ensure      => $ensure,
    command     => "${sleep}cinder-manage db purge ${age} >>${destination} 2>&1",
    environment => 'PATH=/bin:/usr/bin:/usr/sbin SHELL=/bin/sh',
    user        => $user,
    minute      => $minute,
    hour        => $hour,
    monthday    => $monthday,
    month       => $month,
    weekday     => $weekday,
    require     => Anchor['cinder::dbsync::end'],
  }
}
