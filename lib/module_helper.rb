require_relative "unknown_data_errors"

module Helper

  def sanitize_data(input)
    input.to_s.gsub!(/[\s]+/,'')
    input = input.to_f if String === input
    value = input.nan? ? 0 : input
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
