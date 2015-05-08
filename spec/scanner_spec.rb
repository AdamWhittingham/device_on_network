require 'spec_helper'
require production_code

describe DeviceOnNetwork::Scanner do

    let(:nmap) { double_cmd('nmap') }

    subject( described_class.new '/dev/null', '10.0.0.*' )

    describe '#scan' do
      it 'runs nmap'
      it 'scans the given network segment'
    end
end
