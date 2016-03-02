require 'pry'
require './lib/enrollment'

class District

  attr_accessor :name, :enrollment

  def initialize(args)
    @name = args[:name].upcase
    @enrollment = nil
  end
end
