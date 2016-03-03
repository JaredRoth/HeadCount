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
    # sources = sources.has_key?(:enrollment) ? sources[:enrollment] : sources
    sources = sources[:enrollment] if sources.has_key?(:enrollment)

    sources.each do |source, filename|
      csv_hash = CSV.readlines(filename, headers: true, header_converters: :symbol).map(&:to_h)
      source_hash = {}
      all_districts_info(csv_hash).each do |name, data|
        if find_by_name(name)
          find_by_name(name).grade_data[source] = data
        else
          enrollments << Enrollment.new(name: name, source => data)
        end
      end
    end
  end

  def group_data(data)
    data.group_by { |row| row[:location].upcase }
  end

  def all_districts_info(data)
    data_grouped_by_location = group_data(data)
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

# e_repo = EnrollmentRepository.new
# e_repo.load_data({
#   :enrollment => {
#     :kindergarten => "./test_data/sample_kindergartners_file.csv",
#     :high_school_graduation => "./test_data/sample_high_school_graduation.csv"
#   }
# })
