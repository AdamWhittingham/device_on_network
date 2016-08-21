require 'nmap/xml'

module DeviceOnNetwork
  class Parser

    def initialize scan_file
      @scan_file = scan_file
    end

    def active_macs
      scan.hosts
        .select{|host| host.status.state == :up}
        .map(&:mac)
        .compact
    end

    def active_macs_and_ip
      scan.hosts
        .select{|host| host.status.state == :up}
        .map{|host| {ip: host.ip, mac: host.mac} }
    end

    def tidy_mac mac
      mac.upcase
        .gsub(':','')
        .chars
        .each_slice(2)
        .map(&:join)
        .join(':')
    end

    private def scan
      Nmap::XML.new(@scan_file)
    end

  end
end
