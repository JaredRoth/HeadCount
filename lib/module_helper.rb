module Helper

  #input = 0 .123
  #=> 0.123
  def sanitize_data(input)
    input.to_s.gsub(/[\s]+/,'').to_f
  end


end
