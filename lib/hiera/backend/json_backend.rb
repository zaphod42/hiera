require 'hiera/answer'
require 'json'

class Hiera::Backend::Json
  def initialize(name, config, logger, interpolater)
    @name = name
    @config = config
    @interpolater = interpolater
    @logger = logger
  end

  def lookup(key)
    answer = nil

    @logger.debug("Looking up #{key} in JSON backend.")

    file = File.join(config['dir'], "#{@name}.#{config['suffix'] || 'json'}")

    @logger.debug("Looking in #{file}.")

    if File.exist?(file)
      data = JSON.load_file(file)

      if data.include?(key)
        Hiera::Answer.something(@interpolater.expand(data[key]))
      else
        Hiera::Answer.nothing
      end
    else
      @logger.warn("Data file #{file} does not exist. No answer.")
      Hiera::Answer.nothing
    end
  end
end
