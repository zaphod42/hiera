require 'hiera/answer'
require 'hiera/backend/array_lookup'
require 'hiera/backend/hash_lookup'
require 'hiera/backend/priority_lookup'

class Hiera::Hierarchy
  def initialize(hierarchy, logger, interpolater)
    @hierarchy = hierarchy
    @logger = logger
    @interpolater = interpolater
  end

  def lookup(key, resolution)
    case resolution
    when :array
      Hiera::Backend::ArrayLookup.new("array lookup",
                                      { 'hierarchy' => @hierarchy },
                                      @logger,
                                      @interpolater).lookup(key)
    when :hash
      Hiera::Backend::HashLookup.new("hash lookup",
                                     { 'hierarchy' => @hierarchy },
                                     @logger,
                                     @interpolater).lookup(key)
    when :priority
      Hiera::Backend::PriorityLookup.new("priority lookup",
                                         { 'hierarchy' => @hierarchy },
                                         @logger,
                                         @interpolater).lookup(key)
    else
      raise "Unknown resolution type: #{resolution}"
    end
  end
end
