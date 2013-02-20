class Hiera
  VERSION = "1.1.2"

  require "hiera/data"
  require "hiera/config"
  require "hiera/console_logger"

  class << self
    def version
      VERSION
    end
  end

  def initialize(config = nil)
    @config = config || Hiera::Config.new({
      'logger' => 'console',
      'hierarchy' => []
    })
  end

  # Calls the backends to do the actual lookup.
  #
  # The scope can be anything that responds to [], if you have input
  # data like a Puppet Scope that does not you can wrap that data in a
  # class that has a [] method that fetches the data from your source.
  # See hiera-puppet for an example of this.
  #
  # The order-override will insert as first in the hierarchy a data source
  # of your choice.
  def lookup(key, default, scope, resolution_type=:priority)
    data = Hiera::Data.new(scope)
    @config.hierarchy(data).lookup(key, resolution_type).otherwise(default)
  end
end

