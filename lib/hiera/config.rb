require 'yaml'

require 'hiera/class_reference'
require 'hiera/backend/hierarchy'

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

  def hierarchy(data)
    Hiera::Backend::Hierarchy.new(@hierarchy.collect do |level|
      level.backend_instance(data, logger)
    end, logger, data)
  end

  class HierarchyLevelConfig
    attr_reader :name, :type, :type_config

    def initialize(name, information)
      @name = name
      @class_ref = Hiera::ClassReference.new(Hiera::Backend, information['type'])
      @type_config = information['config']
    end

    def backend_instance(data, logger)
      @class_ref.load
      @class_ref.create(data.expand(name), type_config, logger, data)
    end
  end
end
