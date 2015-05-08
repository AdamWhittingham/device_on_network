require 'sinatra'
require 'json'
require_relative 'device_on_network'

$scan_file      = ENV['SCAN_OUTPUT']     || '/var/tmp/scanner.xml'
$scan_frequency = ENV['SCAN_FREQUENCY']  || 30
network_target  = ENV['NETWORK_TARGETS'] || '192.168.0.*'

$parser  = DeviceOnNetwork::Parser.new($scan_file)
$scanner = DeviceOnNetwork::Scanner.new($scan_file, network_target)

puts "Starting Scanner"
puts " - Searching: #{network_target}"
puts " - Scan every: #{$scan_frequency} seconds"
puts
puts "Set the NETWORK_TARGETS or SCAN_FREQUENCY environment variables to change these settings"

Thread.start do
  loop do
    start = Time.now
    $scanner.scan
    duration = Time.now - start
    sleep $scan_frequency - duration
  end
end

get '/' do
  JSON.generate({status: 'Running', timestamp: Time.now.utc})
end

get '/find' do
  return 400 unless params[:mac]
  mac = params[:mac]
  host = $parser.find_mac(mac)
  found = !(host.nil? || host.empty?)
  timestamp = File.mtime($scan_file).utc
  JSON.generate({mac: mac, found: found, timestamp: timestamp})
end
