require 'hiera/answer'

class Hiera::Backend::HashLookup
  def initialize(name, config, logger, interpolater)
    @levels = Hiera::Config::HierarchyLevel.parse(config['hierarchy']).collect do |level|
      level.backend_instance(interpolater, logger)
    end
  end

  def lookup(key)
    Hiera::Answer.something(@levels.inject({}) do |so_far, level|
      so_far.merge!(level.lookup(key).otherwise({}))
    end)
  end
end

