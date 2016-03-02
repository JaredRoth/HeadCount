require 'csv'
require 'pry'
require './lib/enrollment'

class District

  attr_reader :enrollment
  attr_accessor :name

  def initialize(args)
    @name = args[:location].upcase
  end

end
