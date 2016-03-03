module Helper

  def sanitize_data(input)
    input.to_s.gsub(/[\s]+/,'').to_f
  end

end
