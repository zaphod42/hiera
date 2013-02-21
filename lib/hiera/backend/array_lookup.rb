require 'hiera/answer'

class Hiera::Backend::ArrayLookup
  def initialize(levels)
    @levels = levels
  end

  def lookup(key)
    Hiera::Answer.something(@levels.collect do |level|
      level.lookup(key).otherwise(nil)
    end.flatten.uniq.compact)
  end
end
