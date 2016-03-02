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
      if districts.none? {|district| district.name == row[:location].upcase}
        districts << District.new(location: row[:location])
      end
    end
  end

  def all
    districts
  end

  def load_data_info(district_in)
    district_in.each { |district| districts << district}
  end

  def find_by_name(location)
    districts.find { |district| district.name == location.upcase }
  end

  def find_all_matching(location)
    districts.find_all { |district|
    district.name.include?(location.upcase)}
  end

end

# ds = DistrictRepository.new
# ds.load_data('./data/Kindergartners in full-day program.csv')
# ds.find_all_matching("AG")
