require 'spec_helper'
require production_code

describe DeviceOnNetwork::Server do
  let(:mac){ '00:00:00:00:00:01' }

  before do
    allow(DeviceOnNetwork::Scanner)
      .to receive(:new)
      .and_return double(:scanner)
  end

  describe 'GET /find?mac=<mac>' do

    context 'there is not matching host' do
      before { device_missing }

      it 'returns JSON with found set to false' do
        get 'find', mac: mac
        expect(json_response['found']).to eq false
      end

    end

    context 'there is a host' do
      before { device_found }

      it 'returns JSON with found set to true' do
        get 'find', mac: mac
        expect(json_response['found']).to eq true
      end

      it 'returns JSON for the host' do
        get 'find', mac: mac
        expect(json_response.keys).to include('host')
      end

    end
  end

  def device_missing
    stub_device_lookup_to_return []
  end

  def device_found
    stub_device_lookup_to_return [ {name: 'foo'} ]
  end

  def stub_device_lookup_to_return ret
    allow(DeviceOnNetwork::Parser)
      .to receive_message_chain(:new, :find_mac)
      .and_return ret
  end
end
