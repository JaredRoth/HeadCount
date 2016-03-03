require_relative 'enrollment'

class District

  attr_accessor :enrollment, :statewide_test, :economic_profile
  attr_reader   :name

  def initialize(args)
    @name             = args[:name].upcase
    @enrollment       = nil
    @statewide_test   = nil
    @economic_profile = nil
  end
end
