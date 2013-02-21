require 'hiera/answer'

class Hiera::Backend::ArrayLookup
  def initialize(name, config, logger, interpolater)
    @levels = Hiera::Config::HierarchyLevel.instances_for(config['hierarchy'],
                                                          interpolater,
                                                          logger)
  end

  def lookup(key)
    Hiera::Answer.something(@levels.collect do |level|
      level.lookup(key).otherwise(nil)
    end.flatten.uniq.compact)
  end
end
