class cinder::keystone::auth (
  $password,
  $auth_name          = 'cinder',
  $email              = 'cinder@localhost',
  $tenant             = 'services',
  $configure_endpoint = true,
  $service_type       = 'volume',
  $public_address     = '127.0.0.1',
  $admin_address      = '127.0.0.1',
  $internal_address   = '127.0.0.1',
  $port               = '8776',
  $volume_version     = 'v1',
  $region             = 'RegionOne'
) {

  Class['keystone::db::sync'] -> Class['cinder::keystone::auth']

  Keystone_user_role["${auth_name}@services"] ~> Service <| name == 'cinder-api' |>

  keystone_user { $auth_name:
    ensure   => present,
    password => $password,
    email    => $email,
    tenant   => $tenant,
  }
  keystone_user_role { "${auth_name}@services":
    ensure  => present,
    roles   => 'admin',
  }
  keystone_service { $auth_name:
    ensure      => present,
    type        => $service_type,
    description => "Cinder Service",
  }

  if $configure_endpoint {
    keystone_endpoint { $auth_name:
      ensure       => present,
      region       => $region,
      public_url   => "http://${public_address}:${port}/${volume_version}/%(tenant_id)s",
      admin_url    => "http://${admin_address}:${port}/${volume_version}/%(tenant_id)s",
      internal_url => "http://${internal_address}:${port}/${volume_version}/%(tenant_id)s",
    }
  }
}
