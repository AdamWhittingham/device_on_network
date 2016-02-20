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

  describe '#tidy_mac' do
    it 'converts malformed MAC addresses to correctly formatted ones' do
      expect( subject.tidy_mac '123456789012' ).to eq '12:34:56:78:90:12'
    end

    it 'converts all letters to uppercase' do
      expect( subject.tidy_mac 'ABCDabcdAbCd' ).to eq 'AB:CD:AB:CD:AB:CD'
    end
  end

end
