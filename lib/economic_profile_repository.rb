require_relative 'economic_profile'
require_relative 'module_helper'
require 'csv'
require 'pry'


class EconomicProfileRepository
  include Helper

  attr_reader :economic_profiles

  def initialize
    @economic_profiles = []
  end

  def load_data(source)
    source[:economic_profile].each do |source, filename|
      csv_hash = CSV.readlines(filename, headers: true, header_converters: :symbol).map(&:to_h)
      source_hash = {}
      all_districts_info(csv_hash).each do |name, data|
        if find_by_name(name)
          find_by_name(name).economic_data[source] = data
        else
          economic_profiles << EconomicProfile.new(name: name, source => data)
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
          one_class_info[line[:timeframe].to_i] = sanitize_data_to_na(line[:data])
        end
        one_districts_info[subject.downcase.gsub(/\W/,'_').to_sym] = one_class_info
      end
      hash_result[name] = one_districts_info
    end
    hash_result
  end

  def find_by_name(location)
    economic_profiles.find { |econ_profile| econ_profile.name.upcase == location.upcase}
  end
end
