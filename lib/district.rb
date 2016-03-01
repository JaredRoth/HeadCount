require 'csv'
require 'pry'

class District

  attr_accessor :timeframe, :data ,:dataformat, :name, :location

  def initialize(args)
    # binding.pry
    @name = @location = args[:name] ||  args[:location]
    # @timeframe = args[:timeframe]
    # @data = args[:data]
    # @dataformat = args[:dataformat]
  end


end
