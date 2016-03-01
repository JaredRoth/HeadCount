require 'csv'
require 'pry'

class District

  attr_accessor :location, :timeframe, :data ,:dataformat

  def initialize(args)
    # binding.pry
    @location = args[:location]
    @timeframe = args[:timeframe]
    @data = args[:data]
    @dataformat = args[:dataformat]
  end


end
