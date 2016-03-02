require 'pry'
# require './lib/enrollment_repository'

class Enrollment

  attr_accessor :name, :timeframe,:data, :dataformat, :kindergarten_participation


  def initialize(args)
    @name = args[:name].upcase #args[:name].upcase
    @kindergarten_participation = truncated_kindergarten_participation(args[:kindergarten_participation])
    # @timeframe = args[:timeframe]
    # @data = args[:data]
  end

  def truncate(value)
    ((value * 1000).floor / 1000.0)
  end

  def truncated_kindergarten_participation(hash)
    hash.map do |year,value|
        [year, truncate(value.to_f)]
    end.to_h
  end

  def kindergarten_participation_by_year
       @kindergarten_participation
  end

  def kindergarten_participation_in_year(year)
    @kindergarten_participation.fetch(year,nil)
  end

end

=begin
er = Enrollment.new
er.load_data({
  :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv"
  }
})
=end
# e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
# p e.name
# p e.kindergarten_participation_by_year
# p e.kindergarten_participation_in_year(2010)
