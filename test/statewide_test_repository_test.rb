require_relative 'test_helper'
require_relative '../lib/statewide_test_repository'
require_relative '../lib/district_repository'


class StatewideRepositoryTest < Minitest::Test

  def setup
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      },
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
    @sr = dr.statewide_repo
  end

  def test_can_load_all_data
    assert_equal 181, @sr.statewide_tests.length
  end

  def test_can_load_from_multiple_sources
    refute_nil @sr.statewide_tests[0]
    refute_nil @sr.statewide_tests[0]
  end

  def test_can_load_single_data
    result = @sr.find_by_name("ADAMS-ARAPAHOE 28J")

    assert_equal "ADAMS-ARAPAHOE 28J", result.name
  end

  def test_find_by_name_returns_statewide_test_object
    result = @sr.find_by_name("ADAMS-ARAPAHOE 28J")

    assert_equal StatewideTest, result.class
  end

  def test_does_not_load_duplicate_data
    @sr.statewide_tests.each do |statewide_test|
      assert @sr.statewide_tests.one?{|st| st.name == statewide_test.name}
    end
  end

  def test_value_for_specific_year_is_correct
    statewide_test = @sr.find_by_name("ACADEMY 20")

    assert_equal 0.843, statewide_test.class_data[:eighth_grade]["Reading"]["2008"]
  end

  def test_enrollment_creates_array_of_statewide_tests
    refute @sr.statewide_tests.nil?
    assert_equal 181, @sr.statewide_tests.length
  end

  def test_data_can_be_found_by_name
    statewide_test = @sr.find_by_name("ACADEMY 20")

    assert_equal "ACADEMY 20", statewide_test.name
  end

  def test_find_by_name_is_case_insensitive
    statewide_test = @sr.find_by_name("AcAdEmY 20")

    assert_equal "ACADEMY 20", statewide_test.name
  end

  def test_will_return_nil_if_invalid_name
    assert_nil @sr.find_by_name("Jimmmy")
  end
end
