require_relative 'module_helper'
require 'pry'

class EconomicProfile

  include Helper


  attr_accessor :median_household_income

  def initialize(data)
     @median_household_income = data[:median_household_income]  || {}
   end


def median_household_income_in_year(year)
   raise_error_for_unknown_years_in_ranges(year, @median_household_income.keys)
   incomes = []
   @median_household_income.each_key do |range|
     binding.pry
     next unless x = year.between?(range.first, range.last)
     incomes << @median_household_income[range]
   end
   incomes.reduce(:+) / incomes.count
 end

 def raise_error_for_unknown_years_in_ranges(year, ranges)
     exists = ranges.any? { |range| year.between?(range.first, range.last) }
       raise UnknownDataError unless exists
  end


end


   data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }
economic_profile = EconomicProfile.new(data)

puts economic_profile.median_household_income_in_year(2015)
