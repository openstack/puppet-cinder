# == Class: cinder::deps
#
#  cinder anchors and dependency management
#
class cinder::deps {
  # Setup anchors for install, config and service phases of the module.  These
  # anchors allow external modules to hook the begin and end of any of these
  # phases.  Package or service management can also be replaced by ensuring the
  # package is absent or turning off service management and having the
  # replacement depend on the appropriate anchors.  When applicable, end tags
  # should be notified so that subscribers can determine if installation,
  # config or service state changed and act on that if needed.
  anchor { 'cinder::install::begin': }
  -> Package<| tag == 'cinder-package'|>
  ~> anchor { 'cinder::install::end': }
  -> anchor { 'cinder::config::begin': }
  -> Cinder_config<||>
  ~> anchor { 'cinder::config::end': }
  -> anchor { 'cinder::db::begin': }
  -> anchor { 'cinder::db::end': }
  ~> anchor { 'cinder::dbsync::begin': }
  -> anchor { 'cinder::dbsync::end': }
  ~> anchor { 'cinder::service::begin': }
  ~> Service<| tag == 'cinder-service' |>
  ~> anchor { 'cinder::service::end': }

  # paste-api.ini config should occur in the config block also.
  Anchor['cinder::config::begin']
  -> Cinder_api_paste_ini<||>
  ~> Anchor['cinder::config::end']

  # all db settings should be applied and all packages should be installed
  # before dbsync starts
  Oslo::Db<||> -> Anchor['cinder::dbsync::begin']

  # policy config should occur in the config block also.
  Anchor['cinder::config::begin']
  -> Openstacklib::Policy::Base<||>
  ~> Anchor['cinder::config::end']

  # Support packages need to be installed in the install phase, but we don't
  # put them in the chain above because we don't want any false dependencies
  # between packages with the cinder-package tag and the cinder-support-package
  # tag.  Note: the package resources here will have a 'before' relationshop on
  # the cinder::install::end anchor.  The line between cinder-support-package and
  # cinder-package should be whether or not cinder services would need to be
  # restarted if the package state was changed.
  Anchor['cinder::install::begin']
  -> Package<| tag == 'cinder-support-package'|>
  -> Anchor['cinder::install::end']

  # Support services need to be started in the service phase, but we don't
  # put them in the chain above because we don't want any false dependencies
  # between them and cinder services. Note: the service resources here will
  # have a 'before' relationshop on the cinder::service::end anchor.
  # The line between cinder-support-service and cinder-service should be
  # whether or not cinder services would need to be restarted if the service
  # state was changed.
  Anchor['cinder::service::begin']
  -> Service<| tag == 'cinder-support-service'|>
  -> Anchor['cinder::service::end']

  # We need openstackclient before marking service end so that cinder
  # will have clients available to create resources. This tag handles the
  # openstackclient but indirectly since the client is not available in
  # all catalogs that don't need the client class (like many spec tests)
  Package<| tag == 'openstack'|>
  ~> Anchor['cinder::service::end']

  # The following resources need to be provisioned after the service is up.
  Anchor['cinder::service::end']
  -> Cinder_type<||>

  # Installation or config changes will always restart services.
  Anchor['cinder::install::end'] ~> Anchor['cinder::service::begin']
  Anchor['cinder::config::end']  ~> Anchor['cinder::service::begin']
}
