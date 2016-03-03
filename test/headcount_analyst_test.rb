require_relative 'test_helper'
require_relative '../lib/headcount_analyst'

class HeadcountAnalystTest < Minitest::Test

  def setup
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/sample_kindergartners_file.csv"}})
    @ha = HeadcountAnalyst.new(dr)
  end

  def test_Kindergarten_participation_average
    skip
    assert_equal 0.766, @ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  end

  def test_Kindergarten_participation_comparison_year_over_year
    skip
    year_over_year = {2007=>0.992, 2006=>1.05, 2005=>0.96, 2004=>1.258, 2008=>0.717, 2009=>0.652, 2010=>0.681, 2011=>0.727, 2012=>0.687, 2013=>0.693, 2014=>0.661}

    assert_equal year_over_year, @ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
  end

  def test_Kindergarten_participation_comparison_district_vs_district_over_time_period
    skip
    district_vs_district = {2007=>0.826, 2006=>0.954, 2005=>1.328, 2004=>1.735, 2008=>0.801, 2009=>0.534, 2010=>0.472, 2011=>0.514, 2012=>0.491, 2013=>0.498, 2014=>0.504}

    assert_equal district_vs_district, @ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'ADAMS-ARAPAHOE 28J')
  end

  def test_kindergarten_participation_comparison_district_with_multiple_years_vs_district_with_one_year_data
    skip
    district_vs_district = {2007=>0.826, 2006=>0.954, 2005=>1.328, 2004=>1.735, 2008=>0.801, 2009=>0.534, 2010=>0.472, 2011=>0.514, 2012=>0.491, 2013=>0.498, 2014=>0.504}

    assert_equal district_vs_district, @ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT1')
  end

  def test_truncate_any_given_value
    assert_equal 0.432, @ha.truncate(0.432154)
  end

  def test_kindergarten_participation_variation_compare_to_the_high_school_graduation_variation?
    skip
    assert_equal 1.234, @ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')
  end

  def test_Kindergarten_participation_predict_high_school_graduation_rate_for_district
    skip
    assert_equal true, @ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
  end

  def test_Kindergarten_participation_predict_high_school_graduation_returns_true_if_above_70_percent_the_state
    skip
    assert_equal true, @ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
  end

  def test_Kindergarten_participation_predict_high_school_graduation_returns_false_if_under_70_percent_the_state
    skip
    refute_equal true, @ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'someschool')
  end

  def test_kindergarten_participation_accross_several_districts
    skip
    assert_equal true,
    @ha.kindergarten_participation_correlates_with_high_school_graduation(
  :across => ['district_1', 'district_2', 'district_3', 'district_4'])
  end

  def test_need_to_create_more_test

  end

end
