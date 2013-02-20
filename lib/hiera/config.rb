require 'yaml'

require 'hiera/class_reference'
require 'hiera/hierarchy'

class Hiera::Config
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
    @hierarchy = config_data['hierarchy'].collect { |level| HierarchyLevelConfig.new(level) }
  end

  def logger
    @logger_config[:class_ref].load
    @logger_config[:class_ref].create(@logger_config[:config])
  end

  def hierarchy(interpolater)
    Hiera::Hierarchy.new(@hierarchy.collect do |level|
      level.backend_instance(interpolater, logger)
    end, logger, interpolater)
  end

  class HierarchyLevelConfig
    attr_reader :name, :type, :type_config

    def initialize(information)
      @name = information['name']
      @class_ref = Hiera::ClassReference.new(Hiera::Backend, information['type'])
      @type_config = information['config']
    end

    def backend_instance(interpolater, logger)
      @class_ref.load
      @class_ref.create(interpolater.expand(name), type_config, logger, interpolater)
    end
  end
end
