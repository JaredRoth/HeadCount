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
      source_hash = {}
      all_districts_info(csv_hash).each do |name, data|
        if find_by_name(name)
          find_by_name(name).class_data[source] = data
        else
          statewide_tests << StatewideTest.new(name: name, source => data)
        end
      end
    end
  end

  def group_data_by_location(data)
    data.group_by { |row| row[:location].upcase }
  end

  def group_data_by_subject(data)
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
    data_grouped_by_location = group_data_by_location(data)
    hash_result = {}
    data_grouped_by_location.each do |name,full_hash_of_data|
      data_grouped_by_subject = group_data_by_subject(full_hash_of_data)
      one_districts_info = {}
      data_grouped_by_subject.each do |subject, data|
        one_class_info = {}
        data.each do |line|
          one_class_info[line[:timeframe].to_i] = sanitize_data(line[:data])
        end
        one_districts_info[subject.downcase.gsub(/\W/,'_').to_sym] = one_class_info
      end
      hash_result[name] = one_districts_info
    end
    hash_result
  end

  def find_by_name(location)
    statewide_tests.find { |statewide_test| statewide_test.name.upcase == location.upcase}
  end
end
