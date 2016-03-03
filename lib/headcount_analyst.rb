require_relative 'module_helper'
require_relative 'district_repository'
class HeadcountAnalyst
  include Helper
  attr_reader :dr

  def initialize(dr)
    @dr = dr
  end


  def compute_average_from_participation_hash(participation_hash)
    participation_total = participation_hash.values.reduce(:+)
    total_years = participation_hash.length
    participation_total / total_years
  end

  def calculate_participation_average(district_name)
    district = @dr.find_by_name(district_name)
    participation_hash = district.enrollment.kindergarten_participation_by_year
      compute_average_from_participation_hash(participation_hash)
  end

  def kindergarten_participation_rate_variation(district_name, params)
    district_average = calculate_participation_average(district_name)
    state_name = params[:against]
    state_average = calculate_participation_average(state_name)
    truncate(district_average / state_average)
  end

  def kindergarten_participation_rate_variation_trend(district_name, params)
    state_name = params[:against]
    district = @dr.find_by_name(district_name)
    district_participation_hash = district.enrollment.kindergarten_participation_by_year
    compute_state_district_participation_trend(state_name,district_participation_hash)
  end

  def compute_state_district_participation_trend(state_name,district_participation_hash)
    state = @dr.find_by_name(state_name)
    district_participation_hash.map do |year,value|
      state_value = state.enrollment.kindergarten_participation_in_year(year)
      [year,truncate(value/state_value)] unless state_value.nil?
    end.to_h
  end

  def kindergarten_participation_against_high_school_graduation(district_name)
      # compares kindergarten_participation_rate_variation to graduation_rate_by_year
  end

  def kindergarten_participation_correlates_with_high_school_graduation(district_name)


  end


end


# dr = DistrictRepository.new
# dr.load_data({:enrollment => {:kindergarten => "./data/sample_kindergartners_file.csv"}})
# ha = HeadcountAnalyst.new(dr)
# p ha.kindergarten_participation_rate_variation('ACADEMY 20', against: 'Colorado')
