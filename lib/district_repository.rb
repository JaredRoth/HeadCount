require_relative 'repository'
require_relative 'district'
require_relative 'enrollment_repository'
require 'csv'

class DistrictRepository < Repository

  attr_reader :districts

  def initialize
    @data = load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
    })
    #binding.pry
    @districts = group_data.keys
  end

  def find_by_name(location)
    districts.find { |district| district.upcase == location.upcase }
  end

  def find_all_matching(location)
    districts.find_all { |district| district.upcase.include?(location.upcase)}
  end
end
=begin
dr = DistrictRepository.new
p dr.find_by_name("ADAMS COUNTY 14")
p dr.find_by_name("Not Found Should Be nil")
p dr.find_all_matching("Ad")
binding.pry
=end
