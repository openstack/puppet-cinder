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
         :name               => 'Backend_1',
         :ensure             => :present,
         :properties         => ['key=value', 'new_key=a-new_value', 'multiattach="<is> True"'],
         :is_public          => true,
         :access_project_ids => [],
      }
    end

    let(:resource) do
      Puppet::Type::Cinder_type.new(type_attributes)
    end

    let(:provider) do
      provider_class.new(resource)
    end

    before(:each) { set_creds_env }

    describe 'managing type' do
      describe '#create' do
        it 'creates a type' do
          expect(provider_class).to receive(:openstack)
            .with('volume type', 'create', '--format', 'shell', ['--property', 'key=value', '--property', 'new_key=a-new_value', '--property', 'multiattach="<is> True"', '--public', 'Backend_1'])
            .and_return('id="90e19aff-1b35-4d60-9ee3-383c530275ab"
name="Backend_1"
properties="key=\'value\', new_key=\'a-new_value\', multiattach=\'<is> True\'"
is_public="True"
access_project_ids=""
')
          provider.create
          expect(provider.exists?).to be_truthy
        end
      end

      describe '#destroy' do
        it 'destroys a type' do
          expect(provider_class).to receive(:openstack)
            .with('volume type', 'delete', 'Backend_1')
          provider.destroy
          expect(provider.exists?).to be_falsey
        end
      end

      describe '#instances' do
        it 'finds types' do
          expect(provider_class).to receive(:openstack)
            .with('volume type', 'list', '--quiet', '--format', 'csv', '--long')
            .and_return('"ID","Name","Is Public","Properties"
"28b632e8-6694-4bba-bf68-67b19f619019","type-1","True","key1=\'value1\'"
"4f992f69-14ec-4132-9313-55cc06a6f1f6","type-2","False","key2=\'value2\'"
')
          expect(provider_class).to receive(:openstack)
            .with('volume type', 'show', '--format', 'shell', '4f992f69-14ec-4132-9313-55cc06a6f1f6')
            .and_return('
id="4f992f69-14ec-4132-9313-55cc06a6f1f6"
name="type-2"
properties="key2=\'value2\'"
is_public="False"
access_project_ids="54f4d231201b4944a5fa4587a09bda23, 54f4d231201b4944a5fa4587a09bda28"
')

          instances = provider_class.instances
          expect(instances.count).to eq(2)
          expect(instances[0].name).to eq('type-1')
          expect(instances[1].name).to eq('type-2')
          expect(instances[0].is_public).to be true
          expect(instances[1].is_public).to be false
          expect(instances[0].access_project_ids).to match_array([])
          expect(instances[1].access_project_ids).to match_array(['54f4d231201b4944a5fa4587a09bda23', '54f4d231201b4944a5fa4587a09bda28'])
        end

        it 'finds types with a Properties hash' do
          expect(provider_class).to receive(:openstack)
            .with('volume type', 'list', '--quiet', '--format', 'csv', '--long')
            .and_return('"ID","Name","Is Public","Properties"
"28b632e8-6694-4bba-bf68-67b19f619019","type-1","True","{\'key1\': \'value1\'}"
"4f992f69-14ec-4132-9313-55cc06a6f1f6","type-2","False","{\'key2\': \'value2\'}"
')
          expect(provider_class).to receive(:openstack)
            .with('volume type', 'show', '--format', 'shell', '4f992f69-14ec-4132-9313-55cc06a6f1f6')
            .and_return('
id="4f992f69-14ec-4132-9313-55cc06a6f1f6"
name="type-2"
properties="key2=\'value2\'"
is_public="False"
access_project_ids="54f4d231201b4944a5fa4587a09bda23, 54f4d231201b4944a5fa4587a09bda28"
')
          instances = provider_class.instances
          expect(instances.count).to eq(2)
          expect(instances[0].properties).to eq(["key1=value1"])
          expect(instances[1].properties).to eq(["key2=value2"])
        end
      end

      describe '#string2array' do
        it 'should return an array with key-value' do
          s = "key='value', key2='value2'"
          expect(provider_class.string2array(s)).to eq(['key=value', 'key2=value2'])
        end
      end

      describe '#pythondict2array' do
        it 'should return an array with key-value when provided with a python dict' do
          s = "{'key': 'value', 'key2': 'value2'}"
          expect(provider_class.pythondict2array(s)).to eq(['key=value', 'key2=value2'])
        end
      end

      describe '#parsestring' do
        it 'should call string2array when provided with a string' do
          s = "key='value', key2='value2'"
          expect(provider_class.parsestring(s)).to eq(['key=value', 'key2=value2'])
        end

        it 'should call pythondict2array when provided with a hash' do
          s = "{'key': 'value', 'key2': 'value2'}"
          expect(provider_class.parsestring(s)).to eq(['key=value', 'key2=value2'])
        end
      end
    end
end
