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

  def test_can_find_by_school_location

    @ds.load_data_info([@d1,@d2,@d6])
    assert_equal 3, @ds.all.length

    district = @ds.find_by_name("Jumpstart")

    assert_equal "JumpStart", district.location

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
    @dr.load_data('./data/sample_kindergartners_file.csv')
  end

  def test_loads_data
    assert_equal "Colorado", @dr.districts[0].location
  end

  def test_can_find_by_school_name
    district = @dr.find_by_name("ACADEMY 20")

    assert_equal "ACADEMY 20", district.location
  end

  def test_can_find_one_matching_school_by_location

    districts = @dr.find_all_matching("Akron")
    assert_equal 1, districts.length
    assert_equal "AKRON", districts.first.location
    assert_equal "AKRON", districts.last.name
  end

  def test_can_find_all_matching_schools_by_location

    districts = @dr.find_all_matching("ad")
    assert_equal 2, districts.length
    assert_equal "ADAMS COUNTY 14", districts[0].location
    assert_equal "ADAMS-ARAPAHOE 28J", districts[1].name
  end

  def test_will_return_nil_if_invalid_location

    district = @dr.find_by_name("20")
    assert_nil district
  end

  def test_will_find_by_name_regardless_of_case

    district = @dr.find_by_name("AcAdEmY 20")
    assert_equal "ACADEMY 20", district.location
  end

  def test_will_find_all_districts_by_location_is_case_insensitive

    district = @dr.find_all_matching("COloRADo")
    assert_equal 1, district.length
    assert_equal "COLORADO", district[0].name
  end

end
