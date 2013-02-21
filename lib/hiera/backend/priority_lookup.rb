require 'hiera/answer'

class Hiera::Backend::PriorityLookup
  def initialize(levels)
    @levels = levels
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


