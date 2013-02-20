module Hiera
  VERSION = "2.0.0"

  module Backend; end
  module Logger; end

  require "hiera/interpolation"
  require "hiera/config"

  def self.version
    VERSION
  end
end

