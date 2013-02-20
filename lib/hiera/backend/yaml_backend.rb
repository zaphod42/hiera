require 'hiera/answer'
require 'yaml'

class Hiera::Backend::Yaml
  def initialize(name, config, logger, interpolater)
    @name = name
    @config = config
    @interpolater = interpolater
    @logger = logger
  end

  def lookup(key)
    answer = nil

    @logger.debug("Looking up #{key} in YAML backend.")

    file = File.join(config['dir'], "#{@name}.#{config['suffix'] || 'yaml'}")

    @logger.debug("Looking in #{file}.")

    if File.exist?(file)
      data = YAML.load_file(file)

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
