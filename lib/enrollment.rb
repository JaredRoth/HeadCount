require 'pry'


class Enrollment

  attr_accessor :name

  def initialize(args)
    @name = args[:name].upcase
    @participation = {}
    retrieve_data(args)
  end

  def truncate(value)
    ((value * 1000).floor / 1000.0)
  end

  def truncate_percentages(hash)
    hash.map do |year,value|
      [year.to_i, truncate(value.to_f)]
    end.to_h
  end

  def kindergarten_participation_by_year
    @participation[:kindergarten_participation]
  end

  def kindergarten_participation_in_year(year)
    @participation[:kindergarten_participation].fetch(year, nil)
  end

  def graduation_rate_by_year
    @participation[:high_school]
  end

  def graduation_rate_in_year(year)
    @participation[:high_school].fetch(year, nil)
  end

  def retrieve_data(args)
    args.each_pair do |key,value|
      next if key === :name
      @participation[key] = truncate_percentages(args[key])
    end
  end
end
