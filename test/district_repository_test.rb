require './test/test_helper'


class DistrictRepositoryTest < Minitest::Test

  def setup
    @ds = DistrictRepository.new
    @d1 = District.new(location: "Turing", timeframe: "2015", dataformat: "Percent", data: "0.888")
    @d2 = District.new(location: "Turing", timeframe: "2014", dataformat: "Percent", data:"0.9881")
    @d3 = District.new(location: "Turing", timeframe: "2015", dataformat: "Percent", data:"0.2222")
    @d4 = District.new(location: "Turing", timeframe: "2015", dataformat: "Percent", data:"0.7854")
    @d5 = District.new(location: "Turing", timeframe: "2015", dataformat: "Percent", data:"0.128")
    @d6 = District.new(location:"JumpStart", timeframe: "2012", dataformat:"Percent", data: "0.342")
    @d7 = District.new(location:"JumpStart", timeframe: "2012", dataformat:"Percent", data: "0.772")
    @d8 = District.new(location:"JumpStart", timeframe: "2012", dataformat:"Percent", data: "0.352")
    @d9 = District.new(location:"Galvanize", timeframe: "2012", dataformat:"Percent", data: "0.342")
    @d10 = District.new(location:"Galvanize", timeframe: "2012", dataformat:"Percent", data: "0.142")
  end


  def test_by_default_has_no_locations
    assert_equal 0, @ds.all.length
  end

  def test_can_load_single_location

    @ds.load_data_info([@d1])
    assert_equal 1, @ds.all.length
    assert_equal "Turing", @ds.all[0].location
  end

  def test_can_find_by_school_name

    @ds.load_data_info([@d1,@d2,@d6])
    assert_equal 3, @ds.all.length

    district = @ds.find_by_name("Jumpstart")

    assert_equal "JumpStart", district.location
    assert_equal "2012", district.timeframe
    assert_equal "0.342", district.data
    assert_equal "Percent", district.dataformat
  end

  def test_can_find_all_matching_schools_by_location

    @ds.load_data_info([@d1, @d2, @d3, @d4, @d5, @d6, @d7, @d8, @d9, @d10])
    districts = @ds.find_all_matching("Jump")
    assert_equal 3, districts.length
  end
end

class FromFileDistrictRepositoryTest < Minitest::Test

  def setup
    @dr = DistrictRepository.new
  end

  def test_loads_data
    @dr.load_data('./data/Kindergartners in full-day program.csv')
    assert_equal "Colorado", @dr.all[0].location
  end

  def test_can_find_by_school_name
    @dr.load_data('./data/Kindergartners in full-day program.csv')
    district = @dr.find_by_name("ACADEMY 20")

    assert_equal "ACADEMY 20", district.location
    assert_equal "2007", district.timeframe
    assert_equal "Percent", district.dataformat
    assert_equal "0 .39159", district.data
  end

  def test_can_find_all_matching_schools_by_location
    @dr.load_data('./data/Kindergartners in full-day program.csv')
    district = @dr.find_all_matching("Akron")
    assert_equal 11, district.length
  end

  def test_will_return_nil_if_invalid_location
    @dr.load_data('./data/Kindergartners in full-day program.csv')
    district = @dr.find_by_name("20")
    assert_nil district
  end

  def test_will_find_by_name_regardless_of_case
    @dr.load_data('./data/Kindergartners in full-day program.csv')
    district = @dr.find_by_name("AcAdEmY 20")

    assert_equal "ACADEMY 20", district.location
    assert_equal "2007", district.timeframe
    assert_equal "Percent", district.dataformat
    assert_equal "0 .39159", district.data
  end

  def test_will_find_all_districts_by_location_is_case_insensitive
    @dr.load_data('./data/Kindergartners in full-day program.csv')
    district = @dr.find_all_matching("COloRADo")
    assert_equal 22, district.length
  end

end
