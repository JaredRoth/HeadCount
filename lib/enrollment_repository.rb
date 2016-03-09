require_relative 'enrollment'
require_relative 'module_helper'
require 'csv'


class EnrollmentRepository
  include Helper

  attr_reader :enrollments

  def initialize
    @enrollments = []
  end

  def load_data(sources)
    sources = sources[:enrollment] if sources.has_key?(:enrollment)

    sources.each do |source, filename|
      csv_hash = CSV.readlines(filename, headers: true, header_converters: :symbol).map(&:to_h)
      all_districts_info(csv_hash).each do |name, data|
        if find_by_name(name)
          find_by_name(name).grade_data[source] = data
        else
          enrollments << Enrollment.new(name: name, source => data)
        end
      end
    end
  end

  def find_by_name(location)
    enrollments.find { |enrollment| enrollment.name.upcase == location.upcase}
  end

  private

  def group_data_by_location(data)
    data.group_by { |row| row[:location].upcase }
  end

  def all_districts_info(data)
    group_data_by_location(data).each_with_object({}) do |(name, values), districts|
      districts[name] = values.each_with_object({}) do |row, one_districts_info|
        one_districts_info[row[:timeframe].to_i] = sanitize_data(row[:data])
      end
    end
  end
end
