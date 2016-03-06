require_relative 'test_helper'
require_relative '../lib/economic_profile_repository'
require_relative '../lib/district_repository'

class EconomicProfileRepositoryTest < Minitest::Test

  def setup
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      },
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })
    @epr = dr.economic_repo
  end

  def test_can_load_data_directly
    epr = EconomicProfileRepository.new
    epr.load_data({
                    :economic_profile => {
                      :median_household_income => "./data/Median household income.csv",
                      :children_in_poverty => "./data/School-aged children in poverty.csv",
                      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                      :title_i => "./data/Title I students.csv"
                    }
                  })

    assert_equal 181, epr.economic_profiles.length
  end

  def test_can_load_all_districts
    assert_equal 181, @epr.economic_profiles.length
  end

  def test_parses_year_range_into_array
    assert_equal [2005, 2009], @epr.economic_profiles[0].economic_data[:median_household_income].keys[0]
  end

  def test_lunch_info_is_separated_by_percentage_and_added
    assert_equal 0.432, @epr.economic_profiles[0].economic_data[:free_or_reduced_price_lunch][2014][:percentage]
  end

  def test_lunch_info_is_separated_by_number_and_added
    assert_equal 432, @epr.economic_profiles[0].economic_data[:free_or_reduced_price_lunch][2014][:total]
  end

  def test_grabs_median_household_income_data
    assert @epr.economic_profiles[0].economic_data.has_key?(:median_household_income)
  end

  def test_grabs_children_in_poverty_data
    assert @epr.economic_profiles[0].economic_data.has_key?(:children_in_poverty)
  end

  def test_grabs_free_or_reduced_price_lunch_info
    assert @epr.economic_profiles[0].economic_data.has_key?(:free_or_reduced_price_lunch)
  end

  def test_grabs_title_I_data
    assert @epr.economic_profiles[0].economic_data.has_key?(:title_i)
  end
end
