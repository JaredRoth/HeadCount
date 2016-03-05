require_relative "unknown_data_errors"

module Helper

  def error?(condition)
    raise UnknownDataError unless condition
  end

  def truncate(value)
    value.to_s[0..4].to_f
  end

  def sanitize_data(input)
    input.to_s.gsub!(/[\s]+/,'').to_f
    truncate(input)
  end

  def truncate_percentages(hash)
    hash.map do |year,value|
      [year, truncate(value.to_f)]
    end.to_h
  end
end
