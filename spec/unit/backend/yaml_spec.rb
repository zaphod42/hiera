require 'spec_helper'
require 'tmpdir'
require 'hiera/backend/yaml'
require 'hiera/logger/in_memory'

describe Hiera::Backend::Yaml do
  it "has no answer when the data file does not exist" do
    backend = Hiera::Backend::Yaml.new("testing",
                                       { "dir" => "/does/not/exist" },
                                       Hiera::Logger::InMemory.new({}),
                                       nil)

    backend.lookup("anything").should_not be_defined
  end

  it "has no answer when the data file does not contain the requested key" do
    a_yaml_file("testing.yaml", { "some_key" => "the_value" }) do |directory|
      backend = Hiera::Backend::Yaml.new("testing",
                                         { "dir" => directory },
                                         Hiera::Logger::InMemory.new({}),
                                         nil)

      backend.lookup("not_the_key").should_not be_defined
    end
  end

  it "answers with the value found in the yaml file" do
    a_yaml_file("testing.yaml", { "some_key" => "the_value" }) do |directory|
      backend = Hiera::Backend::Yaml.new("testing",
                                         { "dir" => directory },
                                         Hiera::Logger::InMemory.new({}),
                                         Hiera::Interpolation.new({}))

      backend.lookup("some_key").value.should == "the_value"
    end
  end

  def a_yaml_file(name, data, &block)
    Dir.mktmpdir do |directory|
      File.open(File.join(directory, name), "w") do |file|
        file.write(YAML.dump(data))
      end
      yield directory
    end
  end
end
