require 'pry'
require 'aruba/rspec'
require 'simplecov'
require 'rack/test'

def production_code
  spec = caller[0][/spec.+\.rb/]
  './' + spec.gsub('_spec','').gsub(/spec/, 'lib')
end

def app
  DeviceOnNetwork::Server
end

def json_response
  JSON.parse last_response.body
end

RSpec.configure do |config|
  config.include ArubaDoubles
  config.include Rack::Test::Methods

  config.before :each do
    Aruba::RSpec.setup
  end

  config.after :each do
    Aruba::RSpec.teardown
    FileUtils.rm_rf Dir.glob('working/*')
  end

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

end

SimpleCov.start do
  add_filter '/vendor/'
end
