class Hiera::Logger::InMemory
  attr_reader :messages

  def initialize(config)
    @messages = []
  end

  def warn(message)
    @messages << Message.new(:warn, message)
  end

  def debug(message)
    @messages << Message.new(:debug, message)
  end

  Message = Struct.new(:type, :text)
end
