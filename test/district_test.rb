require './test/test_helper'


class DistrictTest < Minitest::Test


  def setup
    @d4 = District.new(location:"Galvanize", timeframe: "2012", dataformat:"Percent", data: "0.342")
  end

  def test_can_get_district_name
    assert_equal "GALVANIZE", @d4.name
  end

  def test_district_can_access_enrollment_methods
    
  end
end
