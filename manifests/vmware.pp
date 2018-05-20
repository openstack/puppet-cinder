# == Class: cinder::vmware
#
# Creates vmdk specific disk file type & clone type.
#
class cinder::vmware {

  include ::cinder::deps

  cinder_type { 'vmware-thin':
    ensure     => present,
    properties => ['vmware:vmdk_type=thin']
  }

  cinder_type { 'vmware-thick':
    ensure     => present,
    properties => ['vmware:vmdk_type=thick']
  }

  cinder_type { 'vmware-eagerZeroedThick':
    ensure     => present,
    properties => ['vmware:vmdk_type=eagerZeroedThick']
  }

  cinder_type { 'vmware-full':
    ensure     => present,
    properties => ['vmware:clone_type=full']
  }

  cinder_type { 'vmware-linked':
    ensure     => present,
    properties => ['vmware:clone_type=linked']
  }
}
