cinder
=======

7.0.0 - 2015.2 - Liberty

#### Table of Contents

1. [Overview - What is the cinder module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with cinder](#setup)
4. [Implementation - An under-the-hood peek at what the module is doing](#implementation)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Contributors - Those with commits](#contributors)

Overview
--------

The cinder module is a part of [OpenStack](https://github.com/openstack), an effort by the Openstack infrastructure team to provide continuous integration testing and code review for Openstack and Openstack community projects as part of the core software.  The module its self is used to flexibly configure and manage the block storage service for Openstack.

Module Description
------------------

The cinder module is a thorough attempt to make Puppet capable of managing the entirety of cinder.  This includes manifests to provision such things as keystone endpoints, RPC configurations specific to cinder, and database connections.  Types are shipped as part of the cinder module to assist in manipulation of configuration files.

This module is tested in combination with other modules needed to build and leverage an entire Openstack software stack.

Setup
-----

**What the cinder module affects**

* [Cinder](https://wiki.openstack.org/wiki/Cinder), the block storage service for Openstack.

### Installing cinder

    puppet module install openstack/cinder

### Beginning with cinder

To utilize the cinder module's functionality you will need to declare multiple resources. This is not an exhaustive list of all the components needed, we recommend you consult and understand the [core openstack](http://docs.openstack.org) documentation.

**Define a cinder control node**

```puppet
class { 'cinder':
  database_connection     => 'mysql://cinder:secret_block_password@openstack-controller.example.com/cinder',
  rabbit_password         => 'secret_rpc_password_for_blocks',
  rabbit_host             => 'openstack-controller.example.com',
  verbose                 => true,
}

class { 'cinder::api':
  keystone_password       => $keystone_password,
  keystone_enabled        => $keystone_enabled,
  keystone_user           => $keystone_user,
  keystone_auth_host      => $keystone_auth_host,
  keystone_auth_port      => $keystone_auth_port,
  keystone_auth_protocol  => $keystone_auth_protocol,
  service_port            => $keystone_service_port,
  package_ensure          => $cinder_api_package_ensure,
  bind_host               => $cinder_bind_host,
  enabled                 => $cinder_api_enabled,
}

class { 'cinder::scheduler': }
```

**Define a cinder storage node**

```puppet
class { 'cinder':
  database_connection     => 'mysql://cinder:secret_block_password@openstack-controller.example.com/cinder',
  rabbit_password         => 'secret_rpc_password_for_blocks',
  rabbit_host             => 'openstack-controller.example.com',
  verbose                 => true,
}

class { 'cinder::volume': }

class { 'cinder::volume::iscsi':
  iscsi_ip_address => '10.0.0.2',
}
```

**Define a cinder storage node with multiple backends **

```puppet
class { 'cinder':
  database_connection     => 'mysql://cinder:secret_block_password@openstack-controller.example.com/cinder',
  rabbit_password         => 'secret_rpc_password_for_blocks',
  rabbit_host             => 'openstack-controller.example.com',
  verbose                 => true,
}

class { 'cinder::volume': }

cinder::backend::iscsi {'iscsi1':
  iscsi_ip_address => '10.0.0.2',
}

cinder::backend::iscsi {'iscsi2':
  iscsi_ip_address => '10.0.0.3',
}

cinder::backend::iscsi {'iscsi3':
  iscsi_ip_address    => '10.0.0.4',
  volume_backend_name => 'iscsi',
}

cinder::backend::iscsi {'iscsi4':
  iscsi_ip_address    => '10.0.0.5',
  volume_backend_name => 'iscsi',
}

cinder::backend::rbd {'rbd-images':
  rbd_pool => 'images',
  rbd_user => 'images',
}

# Cinder::Type requires keystone credentials
Cinder::Type {
  os_password     => 'admin',
  os_tenant_name  => 'admin',
  os_username     => 'admin',
  os_auth_url     => 'http://127.0.0.1:5000/v2.0/',
}

cinder::type {'iscsi':
  set_key   => 'volume_backend_name',
  set_value => ['iscsi1', 'iscsi2', 'iscsi']
}

cinder::type {'rbd':
  set_key   => 'volume_backend_name',
  set_value => 'rbd-images',
}

class { 'cinder::backends':
  enabled_backends => ['iscsi1', 'iscsi2', 'rbd-images']
}
```

Note: that the name passed to any backend resource must be unique accross all backends otherwise a duplicate resource will be defined.

** Using type and type_set **

Cinder allows for the usage of type to set extended information that can be used for various reasons. We have resource provider for ``type`` and ``type_set`` Since types are rarely defined with out also setting attributes with it, the resource for ``type`` can also call ``type_set`` if you pass ``set_key`` and ``set_value``


Implementation
--------------

### cinder

cinder is a combination of Puppet manifest and ruby code to delivery configuration and extra functionality through types and providers.

### Types

#### cinder_config

The `cinder_config` provider is a children of the ini_setting provider. It allows one to write an entry in the `/etc/cinder/cinder.conf` file.

```puppet
cinder_config { 'DEFAULT/verbose' :
  value => true,
}
```

This will write `verbose=true` in the `[DEFAULT]` section.

##### name

Section/setting name to manage from `cinder.conf`

##### value

The value of the setting to be defined.

##### secret

Whether to hide the value from Puppet logs. Defaults to `false`.

##### ensure_absent_val

If value is equal to ensure_absent_val then the resource will behave as if `ensure => absent` was specified. Defaults to `<SERVICE DEFAULT>`

Limitations
------------

* Setup of storage nodes is limited to Linux and LVM, i.e. Puppet won't configure a Nexenta appliance but nova can be configured to use the Nexenta driver with Class['cinder::volume::nexenta'].

Beaker-Rspec
------------

This module has beaker-rspec tests

To run:

``shell
bundle install
bundle exec rspec spec/acceptance
``

Development
-----------

Developer documentation for the entire puppet-openstack project.

* https://wiki.openstack.org/wiki/Puppet-openstack#Developer_documentation

Contributors
------------

* https://github.com/openstack/puppet-cinder/graphs/contributors
