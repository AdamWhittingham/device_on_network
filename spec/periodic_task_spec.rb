require 'spec_helper'
require production_code

describe PeriodicTask do

  it 'raises an arguement error if invoked without a block' do
    expect{ described_class.run_every(1) }.to raise_error
  end

  it 'raises an arguement error if invoked without a numeric period' do
    expect{ described_class.run_every('a') }.to raise_error
  end

end
