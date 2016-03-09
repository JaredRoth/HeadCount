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
    create_repo(organize_data_by_source(source)).each_value do |value|
      economic_profiles << EconomicProfile.new(value)
    end

    # ######### Ask preference
    # data_collected_by_type = organize_data_by_source(source)
    #
    # all_data_hash = create_repo(data_collected_by_type)
    #
    # all_data_hash.each_value do |value|
    #   economic_profiles << EconomicProfile.new(value)
    # end
  end

  def find_by_name(location)
    economic_profiles.find { |profile| profile.name.upcase == location.upcase}
  end

private

  def create_repo(organized_data)
    organized_data.each_with_object({}) do |(data_metric, districts), all_data_hash|
      districts.each do |name, data|
        if all_data_hash[name].nil?
          all_data_hash[name] = {data_metric => data, :name => name}
        else
          all_data_hash[name][data_metric] = data
        end
      end
    end
  end

  def organize_data_by_source(source)
    source[:economic_profile].map do |data_type, filename|
      csv_as_hash = CSV.readlines(filename, headers: true, header_converters: :symbol).map(&:to_h)
      one_files_data = Hash.new({})
      all_districts_info(csv_as_hash, data_type).each do |name, one_districts_data|
        one_files_data[data_type][name] = one_districts_data
      end
      [data_type, one_files_data[data_type]]
    end.to_h
  end

  def all_districts_info(data, data_type)
    group_data_by_location(data).each_with_object({}) do |(name, values), one_districts_info|
      collect_appropriate_data(name, values, one_districts_info, data_type)
    end
  end

  def group_data_by_location(data)
    data.group_by { |row| row[:location].upcase }
  end

  def collect_appropriate_data(name, value, data, data_type)
    case data_type
    when :median_household_income
      collect_income_data(name, value, data)
    when :children_in_poverty
      collect_poverty_data(name, value, data)
    when :free_or_reduced_price_lunch
      collect_lunch_data(name, value, data)
    when :title_i
      collect_title_I_data(name, value, data)
    end
  end

  def collect_income_data(name, value, data)
    data[name] = value.each_with_object({}) do |row, year_data|
      year_data[row[:timeframe].split('-').map(&:to_i)] = row[:data].to_i
    end
  end

  def collect_poverty_data(name, value, data)
    data[name] = value.each_with_object({}) do |row, year_data|
      year_data[row[:timeframe].to_i] = row[:data].to_f if row[:dataformat].upcase == "PERCENT"
    end
  end

  def collect_lunch_data(name, value, data)
    data[name] = value.each_with_object({}) do |row, year_data|
      initialize_fields(year_data, row)
      fill_num_or_percent(year_data, row)
    end

    data[name].each do |year, data_hash|
      sanitize_data(data_hash[:percentage] = data_hash[:percentage] / 6)
    end
  end

  def collect_title_I_data(name, value, data)
    data[name] = value.each_with_object({}) do |row, year_data|
      year_data[row[:timeframe].to_i] = row[:data].to_f
    end
  end

  def initialize_fields(year_data, row)
    unless year_data.has_key?(row[:timeframe].to_i)
      year_data[row[:timeframe].to_i] = {:percentage => 0, :total => 0}
    end
  end

  def fill_num_or_percent(year_data, row)
    if row[:dataformat].upcase == "NUMBER"
      year_data[row[:timeframe].to_i][:total] += row[:data].to_i
    elsif row[:dataformat].upcase == "PERCENT"
      year_data[row[:timeframe].to_i][:percentage] += row[:data].to_f
    end
  end
end
