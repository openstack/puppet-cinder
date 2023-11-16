require 'puppet/provider/openstack'
require 'puppet/provider/openstack/auth'

class Puppet::Provider::Cinder < Puppet::Provider::Openstack

  extend Puppet::Provider::Openstack::Auth

end
