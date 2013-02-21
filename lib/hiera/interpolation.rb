class Hiera::Interpolation
  INTERPOLATION_POINT = /%{([^}]*)}/

  def initialize(datastore)
    @data = datastore
  end

  def expand(value)
    case value
    when Hash
      Hash[value.collect { |key, value| [expand(key), expand(value)] }]
    when Array
      value.collect { |item| expand(item) }
    when String
      value.gsub(/%{([^}]*)}/) { @data[$1] }
    else
      value
    end
  end
end
