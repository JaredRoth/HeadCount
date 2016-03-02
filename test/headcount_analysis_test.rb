require './test/test_helper'


class HeadcountAnalystTest < Minitest::Test

  def setup
    @ha = HeadcountAnalyst.new

  end


  def test_Kindergarten_participation_average
    ha = HeadcountAnalyst.new

    assert_equal 0.766, @ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  end

  def test_Kindergarten_participation_comparison_year_over_year
    year_over_year = {2009 => 0.652, 2010 => 0.681, 2011 => 0.728 }

    assert_equal year_over_year, @ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
  end


end
