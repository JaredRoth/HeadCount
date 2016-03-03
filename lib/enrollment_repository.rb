require_relative 'enrollment'
require_relative 'module_helper'
require 'csv'


class EnrollmentRepository
  include Helper


  attr_reader :enrollments

  def initialize
    @enrollments = []
  end

  def load_data(files)
    filename = [files[:enrollment][:kindergarten],files[:enrollment][:high_school_graduation]]
    data = CSV.readlines(filename, headers: true, header_converters: :symbol).map(&:to_h)
    build_repo(data)

  end

  def build_repo(data)
    data_grouped_by_location = data.group_by do |row|
      row[:location]
    end
    # binding.pry
    create_enrollments(data_grouped_by_location)
  end

  def find_by_name(location)
    enrollments.find { |enrollment| enrollment.name.upcase == location.upcase}
  end

  def create_enrollments(data_grouped_by_location)
    participation = {}

    data_grouped_by_location.each do |key,value|

      value.each do |line|
        participation[line[:timeframe]] = sanitize_data(line[:data])
      end

      enrollments << Enrollment.new({name: key, kindergarten_participation: participation})
      participation.clear
    end

  end
end
