require 'spec_helper'

describe 'cinder::backend::solidfire' do
  let (:title) { 'solidfire' }

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

  describe 'solidfire volume driver' do
    it 'configure solidfire volume driver' do
      is_expected.to contain_cinder_config('solidfire/volume_driver'
        ).with_value('cinder.volume.drivers.solidfire.SolidFireDriver')
      is_expected.to contain_cinder_config('solidfire/san_ip'
        ).with_value('127.0.0.2')
      is_expected.to contain_cinder_config('solidfire/san_login'
        ).with_value('solidfire_login')
      is_expected.to contain_cinder_config('solidfire/san_password'
        ).with_value('password')
      is_expected.to contain_cinder_config('solidfire/sf_template_account_name'
        ).with_value('openstack-vtemplate')
      is_expected.to contain_cinder_config('solidfire/sf_allow_template_caching'
        ).with_value(false)
      is_expected.to contain_cinder_config('solidfire/volume_backend_name'
        ).with_value('solidfire')
      is_expected.to contain_cinder_config('solidfire/sf_emulate_512'
        ).with_value(true)
      is_expected.to contain_cinder_config('solidfire/sf_allow_tenant_qos'
        ).with_value(false)
      is_expected.to contain_cinder_config('solidfire/sf_account_prefix'
        ).with_value('')
      is_expected.to contain_cinder_config('solidfire/sf_api_port'
        ).with_value('443')
      is_expected.to contain_cinder_config('solidfire/sf_volume_prefix'
        ).with_value('UUID-')
      is_expected.to contain_cinder_config('solidfire/sf_svip'
        ).with_value('')
      is_expected.to contain_cinder_config('solidfire/sf_enable_volume_mapping'
        ).with_value(true)
      is_expected.to contain_cinder_config('solidfire/sf_enable_vag'
        ).with_value(false)
    end

    it 'marks san_password as secret' do
      is_expected.to contain_cinder_config('solidfire/san_password'
        ).with_secret( true )
    end

  end

  describe 'solidfire backend with additional configuration' do
    before :each do
      params.merge!({:extra_options =>
                        {'solidfire/param1' => {'value' => 'value1'}}})
    end

    it 'configure solidfire backend with additional configuration' do
      is_expected.to contain_cinder_config('solidfire/param1').with({
        :value => 'value1',
      })
    end
  end

end
