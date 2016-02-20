class PeriodicTask

  def self.run_every period
    raise ArguementError.new("{self.class} requires a block to run") unless block_given?

    Thread.new do
      loop do
        start = Time.now
        yield
        duration = Time.now - start
        time_to_next_run = [ (period - duration), 0].max
        sleep time_to_next_run
      end
    end
  end

end
