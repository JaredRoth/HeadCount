require_relative 'test_helper'
require_relative '../lib/enrollment_repository'
require_relative '../lib/district_repository'


class EnrollmentRepositoryTest < Minitest::Test

  dr = DistrictRepository.new
  dr.load_data({
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv",
      :high_school_graduation => "./data/High school graduation rates.csv"
    }
  })
  @@er = dr.enrollment_repo

  def test_can_load_all_data
    assert_equal 181, @@er.enrollments.length
  end

  def test_can_load_from_multiple_sources
    assert @@er.enrollments[0].kindergarten_participation_by_year
    assert @@er.enrollments[0].graduation_rate_by_year
  end

  def test_can_load_single_data
    result = @@er.find_by_name("ADAMS-ARAPAHOE 28J")

    assert_equal "ADAMS-ARAPAHOE 28J", result.name
  end

  def test_find_by_name_returns_enrollment_object
    result = @@er.find_by_name("ADAMS-ARAPAHOE 28J")

    assert_equal Enrollment, result.class
  end

  def test_does_not_load_duplicate_data
    @@er.enrollments.each do |enrollment|
      assert @@er.enrollments.one?{|en| en.name == enrollment.name}
    end
  end

  def test_value_for_specific_year_is_correct
    enrollment = @@er.find_by_name("ACADEMY 20")
    assert_equal 0.436, enrollment.kindergarten_participation_in_year(2010)
  end

  def test_enrollment_creates_array_of_enrollments
    refute @@er.enrollments.nil?
    assert_equal 181, @@er.enrollments.length
  end

  def test_enrollment_contains_merged_data
    result = @@er.enrollments.find { |enroll| enroll.name == "ACADEMY 20"}

    e = {2007=>0.391,
   2006=>0.353,
   2005=>0.267,
   2004=>0.302,
   2008=>0.384,
   2009=>0.39,
   2010=>0.436,
   2011=>0.489,
   2012=>0.478,
   2013=>0.487,
   2014=>0.49}

    assert_equal e, result.kindergarten_participation_by_year
  end

  def test_data_can_be_found_by_name
      enrollment = @@er.find_by_name("ACADEMY 20")
      assert_equal 0.436, enrollment.kindergarten_participation_in_year(2010)
  end

  def test_find_by_name_is_case_insensitive
    enrollment = @@er.find_by_name("AcAdEmY 20")

    assert_equal "ACADEMY 20", enrollment.name
  end

  def test_will_return_nil_if_invalid_name
    assert_nil @@er.find_by_name("Jimmmy")
  end
end
