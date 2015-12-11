require 'spec_helper'

describe 'cinder::volume::gpfs' do

  let :params do
  {
      :gpfs_mount_point_base  => '/opt/gpfs/cinder/volumes',
  }
  end

  context 'gpfs volume driver' do

    it 'checks gpfs backend availability' do
      is_expected.to contain_cinder__backend__gpfs('DEFAULT')
    end
  end

end
