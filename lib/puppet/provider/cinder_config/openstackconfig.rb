Puppet::Type.type(:cinder_config).provide(
  :openstackconfig,
  :parent => Puppet::Type.type(:openstack_config).provider(:ruby)
) do

  def self.file_path
    '/etc/cinder/cinder.conf'
  end

end
