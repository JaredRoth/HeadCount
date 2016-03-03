require 'pry'


class Enrollment

  attr_accessor :name

  def initialize(args)
    @name = args[:name].upcase
    @kindergarten_participation = truncate_percentages(args[:kindergarten_participation])
    @high_school_graduation = {} || truncate_percentages(args[:high_school_graduation])
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
    @kindergarten_participation
  end

  def kindergarten_participation_in_year(year)
    @kindergarten_participation.fetch(year, nil)
  end

  def graduation_rate_by_year
    @high_school_graduation
  end

  def graduation_rate_in_year(year)
    @high_school_graduation.fetch(year, nil)
  end
end
