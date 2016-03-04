module Helper

  def sanitize_data(input)
    input.to_s.gsub!(/[\s]+/,'')
    #"0.234" => 0.234
    input = input.to_f if String === input
    input.nan? ? 0 : input
  end

end
