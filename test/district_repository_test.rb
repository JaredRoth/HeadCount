require_relative 'test_helper'
require_relative '../lib/district_repository'


class DistrictRepositoryTest < Minitest::Test

  def setup
    @dr = DistrictRepository.new
    @dr.load_data({:enrollment => {:kindergarten => "./data/sample_kindergartners_file.csv"}})
  end

  def test_loads_data
    assert_equal "COLORADO", @dr.districts[0].name
  end

  def test_loads_entire_file
    assert_equal 7, @dr.districts.count
  end

  def test_can_find_by_school_name
    district = @dr.find_by_name("ACADEMY 20")

    assert_equal "ACADEMY 20", district.name
  end

  def test_can_find_one_matching_school_by_name
    districts = @dr.find_all_matching("Akron")

    assert_equal 1, districts.length
    assert_equal "AKRON R-1", @dr.find_all_matching("Akron").first.name
    assert_equal "AKRON R-1", @dr.find_all_matching("Akron").last.name
  end

  def test_can_find_all_matching_schools_by_name
    districts = @dr.find_all_matching("adams")

    assert_equal 2, districts.length
    assert_equal "ADAMS COUNTY 14", districts[0].name
    assert_equal "ADAMS-ARAPAHOE 28J", districts[1].name
  end

  def test_will_return_nil_if_invalid_name
    district = @dr.find_by_name("20")

    assert_nil district
  end

  def test_find_by_name_is_case_insensitive
    district = @dr.find_by_name("AcAdEmY 20")

    assert_equal "ACADEMY 20", district.name
  end

  def test_find_all_districts_by_name_is_case_insensitive
    districts = @dr.find_all_matching("COloRADo")

    assert_equal 1, districts.length
    assert_equal "COLORADO", districts[0].name
  end

  def test_load_data_builds_enrollment_repo
    result = @dr.enrollment_repo.enrollments

    assert_equal "COLORADO", result[0].name
    assert_equal "ACADEMY 20", result[1].name
  end

  def test_enrollments_link_to_districts
    assert_equal "COLORADO", @dr.find_by_name("COLORADO").enrollment.name
    assert_equal "COLORADO", @dr.districts[0].enrollment.name
  end

end
