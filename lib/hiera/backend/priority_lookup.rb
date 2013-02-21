require 'hiera/answer'

class Hiera::Backend::PriorityLookup
  def initialize(name, config, logger, interpolater)
    @levels = Hiera::Config::HierarchyLevel.instances_for(config['hierarchy'],
                                                          interpolater,
                                                          logger)
  end

  def lookup(key)
    @levels.each do |level|
      answer = level.lookup(key)
      if answer.defined?
        return answer
      end
    end

    Hiera::Answer.nothing
  end
end


