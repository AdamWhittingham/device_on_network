require 'spec_helper'
require production_code

describe DeviceOnNetwork do

  describe '#find_mac' do
    let(:present_device){ '00:00:00:00:00:01' }
    let(:down_device   ){ '00:00:00:00:00:02' }
    let(:missing_device){ 'FF:FF:FF:FF:FF:FF' }

    before do
      double_cmd('nmap')
      FileUtils.copy 'spec/fixtures/scan.xml', 'working/'
    end

    after do
      FileUtils.rm 'working/scan.xml'
    end

    it 'returns the host for the given mac' do
      expect(subject.find_mac(present_device).length).to eq 1
    end

    it 'returns an empty array for devices with down interfaces' do
      expect(subject.find_mac down_device).to eq []
    end

    it 'returns an empty array for missing devices' do
      expect(subject.find_mac missing_device).to eq []
    end

  end

end
