require 'hiera/answer'

class Hiera::Backend::HashLookup
  def initialize(name, config, logger, interpolater)
    @levels = Hiera::Config::HierarchyLevel.instances_for(config['hierarchy'],
                                                          interpolater,
                                                          logger)
  end

  def lookup(key)
    Hiera::Answer.something(@levels.inject({}) do |so_far, level|
      so_far.merge!(level.lookup(key).otherwise({}))
    end)
  end
end

