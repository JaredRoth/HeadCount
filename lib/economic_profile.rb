require_relative 'module_helper'
require 'pry'

class EconomicProfile
  include Helper

  attr_accessor :name, :economic_data

  def initialize(args)
    @name = args[:name].upcase
    @economic_data = {}
    organize_data(args)
  end

  def organize_data(args)
    args.each_pair do |source, subject_hash|
      next if source == :name
      @economic_data[source] = {}
      subject_hash.each do |subject, data|
        @economic_data[source][subject] = data
      end
    end
  end

  def check_range(year)
    @economic_data[:median_household_income].keys.any? do |key|
      year.between?(key[0], key[1])
    end
  end

  def median_household_income_in_year(year)
    error?(check_range(year))
    count = 0
    total = 0
    @economic_data[:median_household_income].each_pair do |range, value|
      if year.between?(range[0], range[1])
        count += 1
        total += value
      end
    end
    total / count
  end

  def median_household_income_average
    # add all range averages
    # divide by number of ranges
  end

  def children_in_poverty_in_year(year)

  end

  def free_or_reduced_price_lunch_percentage_in_year(year)

  end

  def free_or_reduced_price_lunch_number_in_year(year)

  end

  def title_i_in_year(year)

  end

end
