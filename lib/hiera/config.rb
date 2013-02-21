require 'yaml'

require 'hiera/class_reference'
require 'hiera/hierarchy'

class Hiera::Config
  require 'hiera/config/hierarchy_level'

  class << self
    def load(source)
      if File.exist?(source)
        config = YAML.load_file(source)
        Hiera::Config.new(config)
      else
        raise "Config file #{source} not found"
      end
    end
  end

  def initialize(config_data)
    @logger_config = {
      :class_ref => Hiera::ClassReference.new(Hiera::Logger, config_data['logger']['name']),
      :config => config_data['logger']['config']
    }
    @hierarchy = config_data['hierarchy']
  end

  def logger
    @logger_config[:class_ref].load
    @logger_config[:class_ref].create(@logger_config[:config])
  end

  def hierarchy
    @hierarchy
  end
end
