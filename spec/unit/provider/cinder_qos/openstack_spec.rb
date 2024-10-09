require 'puppet'
require 'puppet/provider/cinder_qos/openstack'

provider_class = Puppet::Type.type(:cinder_qos).provider(:openstack)

describe provider_class do

    let(:set_creds_env) do
      ENV['OS_USERNAME']     = 'test'
      ENV['OS_PASSWORD']     = 'abc123'
      ENV['OS_PROJECT_NAME'] = 'test'
      ENV['OS_AUTH_URL']     = 'http://127.0.0.1:5000'
    end

    let(:type_attributes) do
      {
         :name       => 'QoS_1',
         :ensure     => :present,
         :properties => {'key1' => 'value1', 'key2' => 'value2'},
      }
    end

    let(:resource) do
      Puppet::Type::Cinder_qos.new(type_attributes)
    end

    let(:provider) do
      provider_class.new(resource)
    end

    before(:each) { set_creds_env }

    describe 'managing qos' do
      describe '#create' do
        it 'creates a qos' do
          expect(provider_class).to receive(:openstack)
            .with('volume qos', 'create', '--format', 'shell', ['--property', 'key1=value1', '--property', 'key2=value2', 'QoS_1'])
            .and_return('id="e0df397a-72d5-4494-9e26-4ac37632ff04"
name="QoS_1"
properties="{\'key1\': \'value1\', \'key2\': \'value2\'}"
')
          provider.create
          expect(provider.exists?).to be_truthy
        end
      end

      describe '#destroy' do
        it 'destroys a qos' do
          expect(provider_class).to receive(:openstack)
            .with('volume qos', 'delete', 'QoS_1')
          provider.destroy
          expect(provider.exists?).to be_falsey
        end
      end

      describe '#instances' do
        it 'finds qos' do
          expect(provider_class).to receive(:openstack)
            .with('volume qos', 'list', '--quiet', '--format', 'csv', [])
            .and_return('"ID","Name","Consumer","Associations","Properties"
"28b632e8-6694-4bba-bf68-67b19f619019","qos-1","front-end","[\'my_type1\', \'my_type2\']","{\'read_iops\': \'value1\', \'write_iops\':\'value2\'}"
"4f992f69-14ec-4132-9313-55cc06a6f1f6","qos-2","both","[]","{}"
')
          instances = provider_class.instances
          expect(instances.count).to eq(2)
          expect(instances[0].name).to eq('qos-1')
          expect(instances[0].associations).to eq(['my_type1', 'my_type2'])
          expect(instances[0].consumer).to eq('front-end')
          expect(instances[0].properties).to eq({'read_iops'=>'value1', 'write_iops'=>'value2'})
          expect(instances[1].name).to eq('qos-2')
          expect(instances[1].consumer).to eq('both')
          expect(instances[1].associations).to eq([])
          expect(instances[1].properties).to eq({})
        end
      end

      describe '#string2array' do
        it 'should return an array' do
          s = "['foo', 'bar']"
          expect(provider_class.string2array(s)).to eq(['foo', 'bar'])
        end
      end
    end
end
