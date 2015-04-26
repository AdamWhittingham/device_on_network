require 'nmap/program'
require 'nmap/xml'

class DeviceOnNetwork
  MIN_SECONDS_BETWEEN_SCANS = 60
  SCAN_OUTPUT = 'working/scan.xml'

  def initialize targets = '192.168.0.*'
    @network_targets = targets
  end

  def find_mac mac_address
    mac = tidy_mac(mac_address)
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

  def scan
    perform_scan if scan_needed
    Nmap::XML.new(SCAN_OUTPUT)
  end

  def perform_scan
    Nmap::Program.scan do |scan|
      scan.targets = @network_targets
      scan.ports = [20,21,22,53,80,443]
      scan.syn_scan = true
      scan.xml = SCAN_OUTPUT
    end
  end

  def scan_needed
    !(scan_xml_preseent && scanned_recently)
  end

  def scan_xml_preseent
    File.exists? SCAN_OUTPUT
  end

  def scanned_recently
    File.mtime(SCAN_OUTPUT) >= Time.now - MIN_SECONDS_BETWEEN_SCANS
  end

end
