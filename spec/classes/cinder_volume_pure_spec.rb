require 'spec_helper'

describe 'cinder::volume::pure' do

  let :req_params do
    {
      :san_ip            => '127.0.0.2',
      :pure_api_token    => 'abc123def456ghi789'
    }
  end

  describe 'pure volume driver defaults' do
    let :params do
      req_params
    end

    it 'configure pure volume driver' do
      is_expected.to contain_cinder__backend__pure('DEFAULT')
    end
  end

  describe 'pure iscsi volume driver' do
    let :params do
      req_params.merge({
        'pure_storage_protocol' => 'iSCSI',
        'use_chap_auth' => 'true'
      })
    end

    it 'configure pure volume driver' do
      is_expected.to contain_cinder__backend__pure('DEFAULT').with({
        :pure_storage_protocol => 'iSCSI',
        :use_chap_auth => 'true'
      })
    end
  end

  describe 'pure fc volume driver' do
    let :params do
      req_params.merge({'pure_storage_protocol' => 'FC'})
    end

    it 'configure pure volume driver' do
      is_expected.to contain_cinder__backend__pure('DEFAULT').with({
        :pure_storage_protocol => 'FC'
      })
    end
  end

  describe 'pure volume driver with additional configuration' do
    let :params do
      req_params.merge({:extra_options => {'pure_backend/param1' => {'value' => 'value1'}}})
    end

    it 'configure pure volume with additional configuration' do
      is_expected.to contain_cinder__backend__pure('DEFAULT').with({
        :extra_options => {'pure_backend/param1' => {'value' => 'value1'}}
      })
    end
  end

end
