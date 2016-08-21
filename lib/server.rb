require 'sinatra/base'
require 'optparse'
require 'json'
require_relative '../lib/device_on_network'
require_relative '../lib/periodic_task'

module DeviceOnNetwork
  class Server < Sinatra::Base
    # TODO: Find a better way of using Sinatra which allows initialisation without Globals
    set :port,    $port
    set :bind,    $bind

    puts "Started API server"
    puts " - Server port: #{$port}"
    puts " - Server bind: #{$bind}"
    if $show_ips
      puts " - Show IPs: ENABLED"
    end

    @@parser  = DeviceOnNetwork::Parser.new($scan_file)
    @@scanner = DeviceOnNetwork::Scanner.new($scan_file, $network_target)
    PeriodicTask.run_every($scan_period) { @@scanner.scan }

    puts "Started Scanner"
    puts " - Searching: #{$network_target}"
    puts " - Scan every: #{$scan_period} seconds"

    get '/' do
      return '{}' unless File.exists?($scan_file)
      active = $show_ips ? @@parser.active_macs_and_ip : @@parser.active_macs
      timestamp = File.mtime($scan_file).utc
      JSON.generate({ active: active, scanned_at: timestamp })
    end

    Server.run!
  end
end
