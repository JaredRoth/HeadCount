require_relative "unknown_data_errors"

module Helper

  def sanitize_data(input)
    value = input.to_s.gsub(/[\s]+/,'').to_f
    truncate(value)
  end

  def error?(condition)
    raise UnknownDataError unless condition
  end

  def truncate_percentages(hash)
    hash.map do |year,value|
      [year, truncate(value.to_f)]
    end.to_h
  end

  def truncate(value)
    ((value * 1000).floor / 1000.0)
  end
end
