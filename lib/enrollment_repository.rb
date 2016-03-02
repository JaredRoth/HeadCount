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
    data = CSV.readlines(filename, headers: true, header_converters: :symbol).map { |row| row.to_h }
    build_repo(data)
  end

  def build_repo(data)
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

    data_by_location.each do |key,value|
      value.each do |line|
        participation[line[:timeframe]] = line[:data]
      end

      enrollments << Enrollment.new({name: key, kindergarten_participation: participation})
      participation.clear
    end

  end
end
