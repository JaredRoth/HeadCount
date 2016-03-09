require_relative 'statewide_test'
require_relative 'module_helper'
require 'csv'


class StatewideTestRepository
  include Helper

  attr_reader :statewide_tests

  def initialize
    @statewide_tests = []
  end

  def load_data(source)
    source[:statewide_testing].each do |source, filename|
      csv_hash = CSV.readlines(filename, headers: true, header_converters: :symbol).map(&:to_h)
      all_districts_info(csv_hash).each do |name, data|
        if find_by_name(name)
          find_by_name(name).class_data[source] = data
        else
          statewide_tests << StatewideTest.new(name: name, source => data)
        end
      end
    end
  end

  def find_by_name(location)
    statewide_tests.find { |statewide_test| statewide_test.name.upcase == location.upcase}
  end

  def get_grade_data(grade)
    statewide_tests.map{|statewide_test|
      [statewide_test.name, statewide_test.class_data.fetch(grade,0)]
    }.to_h
  end

  private

  def group_by_location(data)
    data.group_by { |row| row[:location].upcase }
  end

  def group_by_subject(data)
    data.group_by { |row| row[class_or_race(row)] }
  end

  def class_or_race(row)
    if row.has_key?(:score)
      :score
    elsif row.has_key?(:race_ethnicity)
      :race_ethnicity
    end
  end

  def all_districts_info(data)
    group_by_location(data).each_with_object({}) do |(name, district_data), subject_data|
      single_district_data(name, district_data, subject_data)
    end
  end

  def single_district_data(name, district_data, subject_data)
    grouped_data = group_by_subject(district_data)

    subject_data[name] = grouped_data.each_with_object({}) do |(subject, data), district_data|
      single_subject_data(subject, data, district_data)
    end
  end

  def single_subject_data(subject, data, district_data)
    one_subject_data = data.each_with_object({}) do |row, subject_data|
      subject_data[row[:timeframe].to_i] = sanitize_data_to_na(row[:data])
    end
    district_data[subject.downcase.gsub(/\W/,'_').to_sym] = one_subject_data
  end
end
