require_relative 'test_helper'
require_relative '../lib/statewide_test_repository'
require_relative '../lib/district_repository'


class StatewideRepositoryTest < Minitest::Test

  def setup
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test_data/sample_kindergartners_file.csv"
      },
      :statewide_testing => {
        :third_grade => "./test_data/sample_3rd_grade.csv",
        :eighth_grade => "./test_data/sample_8th_grade.csv",
        :math => "./test_data/sample_math_proficiency.csv",
        :reading => "./test_data/sample_reading_proficiency.csv",
        :writing => "./test_data/sample_writing_proficiency.csv"
      }
    })
    @sr = dr.statewide_repo
  end

  def test_can_load_all_districts
    assert_equal 7, @sr.statewide_tests.length
  end

  def test_can_load_data_from_all_files
    assert @sr.statewide_tests[0].class_data.has_key?(:third_grade)
    assert @sr.statewide_tests[0].class_data.has_key?(:eighth_grade)
    assert @sr.statewide_tests[0].class_data.has_key?(:math)
    assert @sr.statewide_tests[0].class_data.has_key?(:reading)
    assert @sr.statewide_tests[0].class_data.has_key?(:writing)
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

    assert_equal 0.843, statewide_test.class_data[:eighth_grade][:reading]["2008"]
  end

  def test_enrollment_creates_array_of_statewide_tests
    refute @sr.statewide_tests.nil?
    assert_equal 7, @sr.statewide_tests.length
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
