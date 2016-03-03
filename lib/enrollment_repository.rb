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
    hashes = {}
    files[:enrollment].each do |key, value|
      filename = value
      data = CSV.readlines(filename, headers: true, header_converters: :symbol).map(&:to_h)
      hashes[key] = enrollment_csv_hash(group_data(data))
    end

    kindergarten_info = {}
    hashes[:kindergarten].each do |key, value|
      kindergarten_info[key] = value
    end

    high_school = {}
    hashes[:high_school_graduation].each do |key, value|
      high_school[key] = value
    end

    kindergarten_info.each do |key, value|
      enrollments << Enrollment.new({name: key,
                                    kindergarten_participation: value,
                                    high_school_graduation: high_school[key]})
    end
  end

  def group_data(data)
    data_grouped_by_location = data.group_by { |row| row[:location] }
  end

  def enrollment_csv_hash(data_grouped_by_location)
    hash_result = {}
    data_grouped_by_location.each do |key,value|
      one_districts_info = {}
      value.each do |line|
        one_districts_info[line[:timeframe]] = sanitize_data(line[:data])
      end
      hash_result[key] = one_districts_info
    end
    hash_result
  end

  def find_by_name(location)
    enrollments.find { |enrollment| enrollment.name.upcase == location.upcase}
  end
end
