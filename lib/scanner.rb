require 'nmap/program'

module DeviceOnNetwork
  class Scanner

    DEFAULT_PORTS_TO_SCAN = [ 20, 21, 22, 53, 80, 443, 445, 2049 ]

    def initialize scan_file, network_target, ports_to_scan = DEFAULT_PORTS_TO_SCAN
      @scan_file = scan_file
      @network_targets = network_target
      @ports_to_scan  = ports_to_scan
    end

    def scan
      puts 'Scanning'
      temp_file = Tempfile.new('DeviceOnNetwork')
      Nmap::Program.scan do |scan|
        scan.targets = @network_targets
        scan.ports = @ports_to_scan
        scan.syn_scan = true
        scan.xml = temp_file.path
      end
      FileUtils.chmod "a+r", temp_file
      FileUtils.mv(temp_file, @scan_file)
    end

  end
end
