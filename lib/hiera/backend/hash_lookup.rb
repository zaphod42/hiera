require 'hiera/answer'

class Hiera::Backend::HashLookup
  def initialize(levels)
    @levels = levels
  end

  def lookup(key)
    Hiera::Answer.something(@levels.inject({}) do |so_far, level|
      so_far.merge!(level.lookup(key).otherwise({}))
    end)
  end
end

