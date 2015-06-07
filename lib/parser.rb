require 'nmap/xml'

module DeviceOnNetwork
  class Parser

    def initialize scan_file
      @scan_file = scan_file
    end

    def active_macs
      scan = Nmap::XML.new(@scan_file)
      scan.hosts
        .select{|host| host.status.state == :up}
        .map(&:mac)
        .compact
    end

    def find_mac mac_address
      mac = tidy_mac(mac_address)
      scan = Nmap::XML.new(@scan_file)
      scan.hosts
        .select{|host| host.mac == mac}
        .select{|host| host.status.state == :up}
    end

    private

    def tidy_mac mac
      mac.upcase
        .gsub(':','')
        .chars
        .each_slice(2)
        .map(&:join)
        .join(':')
    end

  end
end
