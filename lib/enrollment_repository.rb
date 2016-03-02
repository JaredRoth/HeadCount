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

    data_by_location = data.group_by do |row|
      row[:location]
    end
    create_enrollments(data_by_location)

  end

  def load_data_info(district_name)
    district_in.each { |district| enrollments << district}
  end

  def find_by_name(location)
    enrollments.find { |enrollment| enrollment.name.upcase == location.upcase}
  end

  def create_enrollments(data_by_location)
    participation = {}
    data_by_location.each do |k,v|
      v.each do |csv|
        participation[csv[:timeframe]] = csv[:data]
      end
      @enrollments << Enrollment.new({name: k, kindergarten_participation: participation})
      participation.clear
    end
  end
end


#p enrollment = er.find_by_name("ACADEMY 20")
