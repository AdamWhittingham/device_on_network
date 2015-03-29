require 'pry'
require 'aruba/rspec'
require 'simplecov'

def production_code
  spec = caller[0][/spec.+\.rb/]
  './' + spec.gsub('_spec','').gsub(/spec/, 'lib')
end

RSpec.configure do |config|
  config.include ArubaDoubles

  config.before :each do
    Aruba::RSpec.setup
  end

  config.after :each do
    Aruba::RSpec.teardown
  end
end

SimpleCov.start do
  add_filter '/vendor/'
end
