require 'hiera/answer'
require 'hiera/backend/array_lookup'
require 'hiera/backend/hash_lookup'
require 'hiera/backend/priority_lookup'

class Hiera::Hierarchy
  def initialize(hierarchy, logger, interpolater)
    @levels = Hiera::Config::HierarchyLevel.parse(hierarchy).collect do |level|
      level.backend_instance(interpolater, logger)
    end
  end

  def lookup(key, resolution)
    case resolution
    when :array
      Hiera::Backend::ArrayLookup.new(@levels).lookup(key)
    when :hash
      Hiera::Backend::HashLookup.new(@levels).lookup(key)
    when :priority
      Hiera::Backend::PriorityLookup.new(@levels).lookup(key)
    else
      raise "Unknown resolution type: #{resolution}"
    end
  end
end
