require_relative 'lib/server'

run Rack::URLMap.new("/" => DeviceOnNetwork::Server)
