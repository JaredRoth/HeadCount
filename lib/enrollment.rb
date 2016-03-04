class Enrollment

  attr_accessor :name, :grade_data

  def initialize(args)
    @name = args[:name].upcase
    @grade_data = {}
    organize_data(args)
  end

  def truncate_percentages(hash)
    hash.map do |year,value|
      [year.to_i, truncate(value.to_f)]
    end.to_h
  end

  def truncate(value)
    ((value * 1000).floor / 1000.0)
  end

  def kindergarten_participation_by_year
    @grade_data[:kindergarten]
  end

  def kindergarten_participation_in_year(year)
    @grade_data[:kindergarten].fetch(year, nil)
  end

  def graduation_rate_by_year
    @grade_data[:high_school_graduation]
  end

  def graduation_rate_in_year(year)
    @grade_data[:high_school_graduation].fetch(year, nil)
  end

  def organize_data(args)
    args.each_pair do |key,value|
      next if key == :name
      if key == :kindergarten_participation
        @grade_data[:kindergarten] = truncate_percentages(args[key])
      else
        @grade_data[key] = truncate_percentages(args[key])
      end
    end
  end
end
