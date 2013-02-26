require 'spec_helper'
require 'hiera/logger/console'

describe Hiera::Logger::Console do
  it "warns to STDERR" do
    STDERR.expects(:puts).with("WARN: 0: foo")
    Time.expects(:now).returns(0)

    logger = Hiera::Logger::Console.new({})

    logger.warn("foo")
  end

  it "should debug to STDERR" do
    STDERR.expects(:puts).with("DEBUG: 0: foo")
    Time.expects(:now).returns(0)

    logger = Hiera::Logger::Console.new({})

    logger.debug("foo")
  end
end
