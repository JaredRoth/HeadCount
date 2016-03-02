require_relative 'district_repository'
class HeadcountAnalyst


  def initialize(dr)
    @dr = dr
    @dr.load_data('./data/sample_kindergartners_file.csv')
  end


  def  compute_average_from_participation_hash(participation_hash)
    participation_total = participation_hash.values.reduce(:+)
    total_years = participation_hash.length

    participation_total / total_years
  end

  def calculate_participation_average(district_name)
    #binding.pry
    district = @dr.find_by_name(district_name)
    participation_hash = district.enrollment.kindergarten_participation_by_year
    #traverse the district participation hash to compute the avg for all years
    compute_average_from_participation_hash(participation_hash)
  end


  def kindergarten_participation_rate_variation(district_name, params)

    district_average = calculate_participation_average(district_name)

    state_name = params[:against]
    state_average = calculate_participation_average(state_name)

    district_average / state_average
  end

  def truncate(value)
    ((value * 1000).floor / 1000.0)
  end

  def kindergarten_participation_rate_variation_trend(district_name, params)
    state_name = params[:against]
    state = @dr.find_by_name(state_name)
    district_participation_hash = district.enrollment.kindergarten_participation_by_year

    district_participation_hash.each_with_index do |year,value,index|
      #perform a lookup for year data for state
      state_value = state.enrollment.kindergarten_participation_in_year(year)
      [year,truncate(value/state_value)] unless state_value.nil?
    end.to_h

  end

end

dr = DistrictRepository.new
ha = HeadcountAnalyst.new(dr)
p ha.kindergarten_participation_rate_variation('ACADEMY 20', against: 'Colorado')