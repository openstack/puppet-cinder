require 'spec_helper'

describe 'cinder::volume::solidfire' do
  let :req_params do
    {
      :san_ip       => '127.0.0.2',
      :san_login    => 'solidfire_login',
      :san_password => 'password',
    }
  end

  let :params do
    req_params
  end

  shared_examples_for 'solidfire volume driver' do
    it 'configure solidfire volume driver' do
      is_expected.to contain_cinder_config('DEFAULT/volume_driver'
        ).with_value('cinder.volume.drivers.solidfire.SolidFireDriver')
      is_expected.to contain_cinder_config('DEFAULT/san_ip'
        ).with_value('127.0.0.2')
      is_expected.to contain_cinder_config('DEFAULT/san_login'
        ).with_value('solidfire_login')
      is_expected.to contain_cinder_config('DEFAULT/san_password'
        ).with_value('password')
      is_expected.to contain_cinder_config('DEFAULT/sf_template_account_name'
        ).with_value('openstack-vtemplate')
      is_expected.to contain_cinder_config('DEFAULT/sf_allow_template_caching'
        ).with_value(false)
      is_expected.to contain_cinder_config('DEFAULT/volume_backend_name'
        ).with_value('solidfire')
      is_expected.to contain_cinder_config('DEFAULT/sf_emulate_512'
        ).with_value(true)
      is_expected.to contain_cinder_config('DEFAULT/sf_allow_tenant_qos'
        ).with_value(false)
      is_expected.to contain_cinder_config('DEFAULT/sf_account_prefix'
        ).with_value('')
      is_expected.to contain_cinder_config('DEFAULT/sf_api_port'
        ).with_value('443')
      is_expected.to contain_cinder_config('DEFAULT/sf_volume_prefix'
        ).with_value('UUID-')
      is_expected.to contain_cinder_config('DEFAULT/sf_svip'
        ).with_value('')
      is_expected.to contain_cinder_config('DEFAULT/sf_enable_volume_mapping'
        ).with_value(true)
      is_expected.to contain_cinder_config('DEFAULT/sf_enable_vag'
        ).with_value(false)
    end

    it 'marks san_password as secret' do
      is_expected.to contain_cinder_config('DEFAULT/san_password'
        ).with_secret( true )
    end

  end

  context 'with solidfire volume drivers additional configuration' do
    before do
      params.merge!({:extra_options => {'solidfire_backend/param1' =>
                                              { 'value' => 'value1' }}})
    end

    it 'configure solidfire volume with additional configuration' do
      is_expected.to contain_cinder__backend__solidfire('DEFAULT').with({
        :extra_options => {'solidfire_backend/param1' => {'value' => 'value1'}}
      })
    end
  end

end
