class Hiera::Data
  INTERPOLATION_POINT = /%{([^}]*)}/

  def initialize(datastore)
    @data = datastore
  end

  def expand(value)
    value.gsub(/%{([^}]*)}/) { @data[$1] }
  end
end
