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

  def test_can_load_all_districts
    assert_equal 7, @epr.economic_profiles.length
  end

  def test_can_load_data_from_all_files
    assert @epr.economic_profiles[0].economic_data.has_key?(:median_household_income)
    assert @epr.economic_profiles[0].economic_data.has_key?(:children_in_poverty)
    assert @epr.economic_profiles[0].economic_data.has_key?(:free_or_reduced_price_lunch)
    assert @epr.economic_profiles[0].economic_data.has_key?(:title_i)
  end

  def test_can_separate_free_or_reduced_eligibility

  end
end
