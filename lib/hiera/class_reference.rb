class Hiera::ClassReference
  def initialize(container, name)
    @container = container
    @name = name
    @class_name = name.gsub(/(?:^(.))|_(.)/) { $1.upcase }
  end

  def load
    directory_name = @container.name.gsub(/::/, '/').downcase
    require "#{directory_name}/#{@name}"
  end

  def create(*args)
    @container.const_get(@class_name).new(*args)
  end
end
