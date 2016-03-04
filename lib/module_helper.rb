module Helper

  def sanitize_data(input)
    input.to_s.gsub!(/[\s]+/,'')
    #"0.234" => 0.234
    input = input.to_f if String === input
    input.nan? ? 0 : input
  end

  def truncate(value)
    ((sanitize_data(value) * 1000).floor / 1000.0)
  end

end
