require './lib/district'
require 'pry'
require 'csv'


class DistrictRepository

  attr_reader :districts

  def initialize
    @districts = []
  end

  def load_data(file)
    filename = String === file ? file : file[:enrollment][:kindergarten]
    data = CSV.open filename, headers: true, header_converters: :symbol

    data.each do |row|
      # binding.pry
      districts << District.new(location: row[:location],
       timeframe: row[:timeframe],
       dataformat: row[:dataformat],
       data: row[:data])

    end
  end

  def all
    districts
  end

  def load_data_info(district_in)
    district_in.each { |district| districts << district}
  end

  def find_by_name(location)
    districts.find { |district| district.location.upcase == location.upcase }
  end

  def find_all_matching(location)
    districts.find_all { |district|
    district.location.upcase.include?(location.upcase)}
  end

end

# ds = DistrictRepository.new
# ds.load_data('./data/Kindergartners in full-day program.csv')
# ds.find_all_matching("AG")
