require 'sinatra'
require 'json'
require_relative 'device_on_network'

class DeviceOnNetwork::Server < Sinatra::Base
  set :bind, '0.0.0.0'

  def initialize
    super
    @devices = DeviceOnNetwork.new
  end

  get '/' do
    "#{Time.now}: DeviceOnNetwork is running"
  end

  get '/find' do
    return 400 unless params[:mac]
    mac_json params[:mac]
  end

  def mac_json mac
    host = @devices.find_mac mac
    output = if host.empty?
               { mac: mac, found: false }
             else
               { mac: mac, found: true, host: host.first }
             end
    JSON.generate output
  end

end
