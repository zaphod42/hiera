module Hiera::Answer
  class Nothing
    def otherwise(alternate)
      alternate
    end

    def value
      raise "Cannot get a value from Nothing"
    end

    def defined?
      false
    end
  end
  NOTHING = Nothing.new

  class Something
    def initialize(value)
      @value = value
    end

    def otherwise(alternate)
      @value
    end

    def value
      @value
    end

    def defined?
      true
    end
  end

  def self.nothing
    NOTHING
  end

  def self.something(value)
    Something.new(value)
  end
end
