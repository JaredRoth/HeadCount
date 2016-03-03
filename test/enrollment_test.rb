require_relative 'test_helper'
require_relative '../lib/enrollment'

class EnrollmentTest < Minitest::Test
  def setup
    @e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
  end

  def test_enrollment_provides_kindergarten_participiation_for_district
    nk = {2010 => 0.391, 2011 => 0.353, 2012 => 0.267}
    assert_equal nk, @e.kindergarten_participation_by_year
  end

  def test_kindergarten_participation_returns_hash_with_year
    nk = {2010 => 0.391, 2011 => 0.353, 2012 => 0.267}
    assert_equal nk, @e.kindergarten_participation_by_year
  end

  def test_kindergarten_participation_returns_specific_year
    assert_equal 0.391, @e.kindergarten_participation_in_year(2010)
  end

  def test_truncates_to_3_digits
    result = @e.truncate(0.3847528305)
    assert_equal 0.384, result
  end

  def test_truncates_hash
    result = @e.truncate_hash_value({2010 => 0.391143, 2011 => 0.353234, 2012 => 0.267234})
    nk = {2010 => 0.391, 2011 => 0.353, 2012 => 0.267}
    assert_equal nk, result
  end

  def test_enrollment_provides_name_for_district
    assert_equal "ACADEMY 20", @e.name
  end

  def test_highschool_graduation_for_specific_year
    skip
    assert_equal 0.895, @e.enrollment.graduation_rate_in_year(2010)
  end

  def test_graduation_rate_by_year
    skip
    nh = {{ 2010 => 0.895, 2011 => 0.895, 2012 => 0.889, 2013 => 0.913, 2014 => 0.898}}

    assert_equal nh, @e.graduation_rate_by_year
  end

  def test_highschool_gradutation_rate_by_year_returns_hash_with_year
    skip
    nk = {2010 => 0.391, 2011 => 0.353, 2012 => 0.267}
    assert_equal nk, @e.graduation_rate_by_year
  end

end
