require './test/test_helper'


class HeadcountAnalystTest < Minitest::Test

  def setup
    @dr = DistrictRepository.new
    @dr.load_data('./data/Kindergartners in full-day program.csv')
    @ha = HeadcountAnalyst.new(@dr)
  end


  def test_Kindergarten_participation_average

    assert_equal 0.766, @ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  end

  def test_Kindergarten_participation_comparison_year_over_year
    year_over_year = {2009 => 0.652, 2010 => 0.681, 2011 => 0.728 }

    assert_equal year_over_year, @ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
  end

  def test_Kindergarten_participation_comparison_district_vs_district_over_time_period
    district_vs_district = {"2007"=>0.992, "2006"=>1.05, "2005"=>0.96, "2004"=>1.258, "2008"=>0.717, "2009"=>0.652, "2010"=>0.681, "2011"=>0.727, "2012"=>0.687, "2013"=>0.693, "2014"=>0.661}
      assert_equal district_vs_district, @ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'ADAMS-ARAPAHOE')
  end


end
