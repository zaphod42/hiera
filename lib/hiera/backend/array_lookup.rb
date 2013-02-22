require 'hiera/answer'

class Hiera::Backend::ArrayLookup
  def initialize(name, config, logger, interpolater)
    @levels = Hiera::Config::HierarchyLevel.instances_for(config['hierarchy'],
                                                          interpolater,
                                                          logger)
  end

  def lookup(key)
    answers = @levels.collect do |level|
      level.lookup(key)
    end.select(&:defined?)

    if answers.empty?
      Hiera::Answer.nothing
    else
      Hiera::Answer.something(answers.collect(&:value).flatten)
    end
  end
end
