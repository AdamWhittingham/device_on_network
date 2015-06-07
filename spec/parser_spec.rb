require 'spec_helper'
require production_code

describe DeviceOnNetwork::Parser do
  let(:present_device){ '00:00:00:00:00:01' }
  let(:down_device   ){ '00:00:00:00:00:02' }
  let(:missing_device){ 'FF:FF:FF:FF:FF:FF' }
  subject{ described_class.new 'spec/fixtures/scan.xml'}

  describe '#active_macs' do
    it 'returns a list of hosts which are up' do
      expect(subject.active_macs.length).to be 3
    end

    it 'returns the mac of each device' do
      expect(subject.active_macs).to include present_device
    end
  end

  describe '#find_mac' do
    it 'returns a host for the given mac' do
      matched = subject.find_mac present_device
      expect(matched.length).to eq 1
      expect(matched.first.class).to eq Nmap::Host
    end

    it 'returns an empty array for devices with down interfaces' do
      expect(subject.find_mac down_device).to eq []
    end

    it 'returns an empty array for missing devices' do
      expect(subject.find_mac missing_device).to eq []
    end

    it 'still works for malformed mac addresses' do
      matched = subject.find_mac '000000:000001'
      expect(matched.length).to eq 1
    end
  end

end
