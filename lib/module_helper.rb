module Helper

  def sanitize_data(input)
    input.to_s.gsub(/[\s]+/,'').to_f
  end

  def truncate(value)
    ((value * 1000).floor / 1000.0)
  end
end
