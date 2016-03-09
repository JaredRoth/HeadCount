require_relative "errors"

module Helper

  def error?(condition)
    raise UnknownDataError unless condition
  end

  def truncate(value)
    value.to_s[0..4].to_f
  end

  def sanitize_data(input)
    input.to_s.gsub!(/[\s]+/,'')
    input = input.to_f if String === input
    truncate(input)
  end

  def sanitize_data_to_na(num)
    sanitize_data(num) == 0 || sanitize_data(num).to_s.upcase.chars[0] == "N" ? "N/A" : sanitize_data(num)
  end

  def sanitize_grade(num)
    {3=>:third_grade,8=>:eighth_grade}.fetch(num,nil)
  end

  def truncate_percentages(hash)
    hash.map do |year,value|
      [year, truncate(value.to_f)]
    end.to_h
  end
end
