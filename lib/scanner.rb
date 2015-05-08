require 'nmap/program'

module DeviceOnNetwork
  class Scanner

    def initialize scan_file, network_target
      @scan_file = scan_file
      @network_targets = network_target
    end

    def scan
      temp_file = Tempfile.new('DeviceOnNetwork') 
      Nmap::Program.scan do |scan|
        scan.targets = @network_targets
        scan.ports = [20,21,22,53,80,443]
        scan.syn_scan = true
        scan.xml = temp_file.path
      end
      FileUtils.chmod "a+r", temp_file
      FileUtils.mv(temp_file, @scan_file)
    end

  end
end
