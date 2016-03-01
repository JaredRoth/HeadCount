require './test/test_helper'

class EnrollmentTest < Minitest::Test


  def test_kindergarten_participation_returns_hash_with_year
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    nk = {2010 => 0.391, 2011 => 0.353, 2012 => 0.267}
    assert_equal nk, e.kindergarten_participation_by_year
  end

  def test_kindergarten_participation_returns_specific_year
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal 0.391, e.kindergarten_participation_in_year(2010)
  end

end
