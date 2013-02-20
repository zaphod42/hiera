class Hiera::Logger::Console
  def initialize(config)
  end

  def warn(msg)
    STDERR.puts("WARN: %s: %s" % [Time.now.to_s, msg])
  end

  def debug(msg)
    STDERR.puts("DEBUG: %s: %s" % [Time.now.to_s, msg])
  end
end
