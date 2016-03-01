require './test/test_helper'


class DistrictTest < Minitest::Test


  def setup
    @d1 = District.new(location: "Turing", timeframe: "2014", dataformat: "Percent", data: "0.888")
    @d2 = District.new(location: "Turing", timeframe: "2015", dataformat: "Percent", data:"0.7854")
    @d3 = District.new(location:"JumpStart", timeframe: "2012", dataformat:"Percent", data: "0.352")
    @d4 = District.new(location:"Galvanize", timeframe: "2012", dataformat:"Percent", data: "0.342")
  end

  def test_can_get_district_location
    assert_equal "Turing", @d1.location
  end

  def test_can_get_district_locations_timeframe
    assert_equal "2015", @d2.timeframe
  end

  def test_can_get_district_dataformat
    assert_equal "Percent", @d3.dataformat
  end

  def test_can_get_districts_data
    assert_equal "0.342", @d4.data
  end

  def test_can_load_all_args
    assert_equal "Galvanize", @d4.location
    assert_equal "2012", @d4.timeframe
    assert_equal "Percent", @d4.dataformat
    assert_equal "0.342", @d4.data
  end

end
