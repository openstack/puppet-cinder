require 'puppet'
require 'puppet/provider/cinder_type/openstack'

provider_class = Puppet::Type.type(:cinder_type).provider(:openstack)

describe provider_class do

    let(:set_creds_env) do
      ENV['OS_USERNAME']     = 'test'
      ENV['OS_PASSWORD']     = 'abc123'
      ENV['OS_PROJECT_NAME'] = 'test'
      ENV['OS_AUTH_URL']     = 'http://127.0.0.1:5000'
    end

    let(:type_attributes) do
      {
         :name       => 'Backend_1',
         :ensure     => :present,
         :properties => ['key=value', 'new_key=new_value'],
      }
    end

    let(:resource) do
      Puppet::Type::Cinder_type.new(type_attributes)
    end

    let(:provider) do
      provider_class.new(resource)
    end

    before(:each) { set_creds_env }

    after(:each) do
      Puppet::Type.type(:cinder_type).provider(:openstack).reset
      provider_class.reset
    end

    describe 'managing type' do
      describe '#create' do
        it 'creates a type' do
          provider_class.expects(:openstack)
            .with('volume type', 'create', '--format', 'shell', ['--property', 'key=value', '--property', 'new_key=new_value', 'Backend_1'])
            .returns('id="90e19aff-1b35-4d60-9ee3-383c530275ab"
name="Backend_1"
properties="key=\'value\', new_key=\'new_value\'"
')
          provider.create
          expect(provider.exists?).to be_truthy
        end
      end

      describe '#destroy' do
        it 'destroys a type' do
          provider_class.expects(:openstack)
            .with('volume type', 'delete', 'Backend_1')
          provider.destroy
          expect(provider.exists?).to be_falsey
        end
      end

      describe '#instances' do
        it 'finds types' do
          provider_class.expects(:openstack)
            .with('volume type', 'list', '--quiet', '--format', 'csv', '--long')
            .returns('"ID","Name","Properties"
"28b632e8-6694-4bba-bf68-67b19f619019","type-1","key1=\'value1\'"
"4f992f69-14ec-4132-9313-55cc06a6f1f6","type-2","key2=\'value2\'"
')
          instances = provider_class.instances
          expect(instances.count).to eq(2)
          expect(instances[0].name).to eq('type-1')
          expect(instances[1].name).to eq('type-2')
        end
      end

      describe '#string2array' do
        it 'should return an array with key-value' do
          s = "key='value', key2='value2'"
          expect(provider_class.string2array(s)).to eq(['key=value', 'key2=value2'])
        end
      end
    end
end
