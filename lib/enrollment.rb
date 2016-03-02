require 'pry'


class Enrollment

  attr_accessor :name

  def initialize(args)
    @name = args[:name].upcase
    @kindergarten_participation = truncated_kindergarten_participation(args[:kindergarten_participation])
  end

  def truncate(value)
    ((value * 1000).floor / 1000.0)
  end

  def truncated_kindergarten_participation(hash)
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
end
