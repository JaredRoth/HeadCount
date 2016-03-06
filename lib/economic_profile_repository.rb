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
    data_collected_by_type = source[:economic_profile].map do |data_type, filename|
      csv_as_hash = CSV.readlines(filename, headers: true, header_converters: :symbol).map(&:to_h)
      one_files_data = Hash.new
      one_files_data[data_type] = {}
      all_districts_info(csv_as_hash, data_type).each do |name, one_districts_data|
        one_files_data[data_type][name] = one_districts_data
      end
      [data_type, one_files_data[data_type]]
    end.to_h

    all_data_hash = {}
    data_collected_by_type.each do |data_metric, districts|
      districts.each do |name, data|
        if all_data_hash[name].nil?
          all_data_hash[name] = Hash[data_metric, data, :name, name]
        else
          all_data_hash[name][data_metric] = data
        end
      end
    end

    all_data_hash.each_value do |value|
      economic_profiles << EconomicProfile.new(value)
    end
  end

  def find_by_name(location)
    economic_profiles.find { |econ_profile| econ_profile.name.upcase == location.upcase}
  end

  private

  def all_districts_info(data, data_type)
    data = group_data_by_location(data)

    # put inside of loop
    decide_data_type(data, data_type)
  end

  def decide_data_type(data, data_type)
    case data_type
    when :median_household_income
      collect_income_data(data)
    when :children_in_poverty
      collect_poverty_data(data)
    when :free_or_reduced_price_lunch
      collect_lunch_data(data)
    when :title_i
      collect_title_I_data(data)
    end
  end

  def collect_income_data(data)
    data.each_with_object({}) do |(name, value), one_districts_info|
      one_districts_info[name] = value.each_with_object({}) do |row, year_data|
        year_data[row[:timeframe].split('-').map(&:to_i)] = row[:data]
      end
    end
  end

  def collect_poverty_data(data)
    data.each_with_object({}) do |(name, value), one_districts_info|
      one_districts_info[name] = value.each_with_object({}) do |row, year_data|
        year_data[row[:timeframe].to_i] = row[:data] if row[:dataformat].upcase == "PERCENT"
      end
    end
  end

  def collect_lunch_data(data)
    data.each_with_object({}) do |(name, value), one_districts_info|
      one_districts_info[name] = value.each_with_object({}) do |row, year_data|
        binding.pry
        year_data[row[:timeframe].to_i] = row[:data]
      end
    end
  end

  def collect_title_I_data(data)
    data.each_with_object({}) do |(name, value), one_districts_info|
      one_districts_info[name] = value.each_with_object({}) do |row, year_data|
        year_data[row[:timeframe].to_i] = row[:data]
      end
    end
  end

  def group_data_by_location(data)
    data.group_by { |row| row[:location].upcase }
  end
end


epr = EconomicProfileRepository.new
epr.load_data({
              :economic_profile => {
                :median_household_income     => "./test_data/sample_median.csv",
                :children_in_poverty         => "./test_data/sample_poverty.csv",
                :free_or_reduced_price_lunch => "./test_data/sample_lunch.csv",
                :title_i                     => "./test_data/sample_title_i.csv"}
              })
