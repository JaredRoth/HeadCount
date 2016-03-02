require_relative 'enrollment'
require_relative 'module_helper'
require 'csv'


class EnrollmentRepository
  include Helper


  attr_reader :enrollments

  def initialize
    @enrollments = []
  end

  def build_repo(data)
    data_grouped_by_location = data.group_by do |row|
      row[:location]
    end
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
        #binding.pry if key.downcase == 'academy 20'
      end

      enrollments << Enrollment.new({name: key, kindergarten_participation: participation})
      participation.clear
    end

  end
end
