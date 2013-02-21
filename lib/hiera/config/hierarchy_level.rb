require 'hiera/class_reference'

class Hiera::Config::HierarchyLevel
  attr_reader :name, :type, :type_config

  def self.parse(hierarchy_list)
    hierarchy_list.collect { |level| Hiera::Config::HierarchyLevel.new(level) }
  end

  def self.instances_for(hierarchy_list, interpolater, logger)
    parse(hierarchy_list).collect do |level|
      level.backend_instance(interpolater, logger)
    end
  end

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
