require_relative 'test_helper'
require_relative '../lib/economic_profile'
require_relative '../lib/economic_profile_repository'

class EconomicProfileTest < Minitest::Test
  def setup
    data = {:median_household_income => {[2014, 2015] => 50000, [2013, 2014] => 60000},
                :children_in_poverty => {2012 => 0.1845},
                :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
                :title_i => {2015 => 0.543},
                :name => "ACADEMY 20"
               }
        @ep = EconomicProfile.new(data)
  end

  def test_can_create_object_from_imported_data
    epr = EconomicProfileRepository.new
    epr.load_data({
                  :economic_profile => {
                    :median_household_income     => "./data/Median household income.csv",
                    :children_in_poverty         => "./data/School-aged children in poverty.csv",
                    :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                    :title_i                     => "./data/Title I students.csv"}
                  })

    assert_equal 181, epr.economic_profiles.count
    assert epr.find_by_name("ACADEMY 20")

    result = epr.find_by_name("ACADEMY 20")
    binding.pry
    # assert_equal 1, result.median_household_income_in_year(2015)
    # assert_equal 1, result.median_household_income_average
    # assert_equal 1, result.children_in_poverty_in_year(2012)
    # assert_equal 1, result.free_or_reduced_price_lunch_percentage_in_year(2014)
    # assert_equal 1, result.free_or_reduced_price_lunch_number_in_year(2014)
    # assert_equal 1, result.title_i_in_year(2015)
  end

  def test_economic_profile_provides_name_for_district
    assert_equal "ACADEMY 20", @ep.name
  end

  def test_children_in_poverty_in_year_returns_UnknownRaceError
    assert_raises UnknownDataError do
      @ep.children_in_poverty_in_year(2030)
    end
  end

  def test_lunch_percentage_returns_UnknownDataError
    assert_raises UnknownDataError do
      @ep.free_or_reduced_price_lunch_percentage_in_year(2030)
    end
  end

  def test_lunch_number_returns_UnknownDataError
    assert_raises UnknownDataError do
      @ep.free_or_reduced_price_lunch_number_in_year(2030)
    end
  end

  def test_title_i_in_year_returns_UnknownDataError
    assert_raises UnknownDataError do
      @ep.title_i_in_year(2030)
    end
  end

  def test_median_household_income_in_year_calculates_properly
    assert_equal 50000, @ep.median_household_income_in_year(2015)
  end

  def test_median_household_income_average_calculates_properly
    assert_equal 55000, @ep.median_household_income_average
  end

  def test_children_in_poverty_in_year_calculates_properly
    assert_equal 0.184, @ep.children_in_poverty_in_year(2012)
  end

  def test_lunch_percentage_calculates_properly
    assert_equal 0.023, @ep.free_or_reduced_price_lunch_percentage_in_year(2014)
  end

  def test_lunch_number_calculates_properly
    assert_equal 100, @ep.free_or_reduced_price_lunch_number_in_year(2014)
  end

  def test_number_of_free_lunches
    skip
  end

  def test_number_of_reduced_price_lunches
    skip
  end

  def test_number_of_ineligable_for_free_lunches
    skip
  end

  def test_title_i_in_year_calculates_properly
    assert_equal 0.543, @ep.title_i_in_year(2015)
  end
end
