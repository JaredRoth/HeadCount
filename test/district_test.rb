require_relative 'test_helper'
require_relative '../lib/district'


class DistrictTest < Minitest::Test
  def setup
    @d4 = District.new(name:"Galvanize", timeframe: "2012", dataformat:"Percent", data: "0.342")
  end

  def test_can_get_district_name
    assert_equal "GALVANIZE", @d4.name
  end

  def test_district_can_access_enrollment_methods
    @d4.enrollment = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal "ACADEMY 20", @d4.enrollment.name
  end
end
