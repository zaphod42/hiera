require 'hiera/answer'

class Hiera::Backend::Hierarchy
  def initialize(levels, logger, data)
    @levels = levels
    @logger = logger
    @data = data
  end

  def lookup(key, resolution)
    case resolution
    when :array
      lookup_array(key)
    when :hash
      lookup_hash(key)
    when :priority
      lookup_priority(key)
    else
      raise "Unknown resolution type: #{resolution}"
    end
  end

private
  def lookup_array(key)
    Hiera::Answer.something(@levels.collect do |level|
      level.lookup(key).otherwise(nil)
    end.flatten.uniq.compact)
  end

  def lookup_hash(key)
    Hiera::Answer.something(@levels.inject({}) do |so_far, level|
      so_far.merge!(level.lookup(key).otherwise({}))
    end)
  end

  def lookup_priority(key)
    @levels.each do |level|
      answer = level.lookup(key)
      if answer.defined?
        return answer
      end
    end

    Hiera::Answer.nothing
  end
end
