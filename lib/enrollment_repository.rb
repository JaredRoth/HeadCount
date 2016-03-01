require 'csv'
require './lib/enrollment'
require 'pry'


class EnrollmentRepository

  attr_reader :enrollments

  def initialize
    @enrollments = []
  end

  def load_data(file)
    filename = String === file ? file : file[:enrollment][:kindergarten]
    data = CSV.open filename, headers: true, header_converters: :symbol

    data.each do |row|
      binding.pry
      enrollments << Enrollment.new(location: row[:location],
       timeframe: row[:timeframe],
       dataformat: row[:dataformat],
       data: row[:data])
    end
  end

  def all
    enrollments
  end

  def load_data_info(district_name)
    district_in.each { |district| enrollments << district}
  end
  
  def find_by_name(location)
    enrollments.find { |enrollment| enrollment.location.upcase == location.upcase}
  end



end

# er = EnrollmentRepository.new
# er.load_data({
#   :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv"
#   }
# })
# #binding.pry
# er = EnrollmentRepository.new
# er.load_data('./data/Kindergartners in full-day program.csv')

#p enrollment = er.find_by_name("ACADEMY 20")
