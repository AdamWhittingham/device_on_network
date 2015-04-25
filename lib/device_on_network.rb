require 'nmap/program'
require 'nmap/xml'

class DeviceOnNetwork
  MIN_SECONDS_BETWEEN_SCANS = 60
  SCAN_OUTPUT = 'working/scan.xml'

  def initialize targets = '192.168.0.*'
    @network_targets = targets
  end

  def find_mac mac_address
    scan.hosts
      .select{|host| host.mac == mac_address.upcase}
      .select{|host| host.status.state == :up}
  end

  private

  def scan
    perform_scan if scan_needed
    Nmap::XML.new(SCAN_OUTPUT)
  end

  def perform_scan
    Nmap::Program.scan do |nmap|
      nmap.targets = @network_targets
      nmap.ports = [20,21,22,53,80,443]
      nmap.syn_scan = false
      nmap.xml = SCAN_OUTPUT
      nmap.verbose = false
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
