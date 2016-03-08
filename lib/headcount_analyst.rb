require_relative 'district_repository'
require_relative 'module_helper'
require_relative 'unknown_data_errors'
require_relative 'statewide_test_repository'



class HeadcountAnalyst
  include Helper

  attr_reader :dr

  def initialize(dr)
    @dr = dr
    @sr = @dr.statewide_repo
  end


  def compute_average_from_participation_hash(participation_hash)
    participation_total = participation_hash.values.map{|val| String === val ? 0 : val}.reduce(:+)
    total_years = participation_hash.length
    participation_total / total_years
  end

  def calculate_kindergartner_participation_average(district_name)
    district = @dr.find_by_name(district_name)
    participation_hash = district.enrollment.kindergarten_participation_by_year
    compute_average_from_participation_hash(participation_hash)
  end

  def calculate_high_school_participation_average(district_name)
    district = @dr.find_by_name(district_name)
    participation_hash = district.enrollment.graduation_rate_by_year
    compute_average_from_participation_hash(participation_hash)
  end

  def kindergarten_participation_rate_variation(district_name, params)
    district_average = calculate_kindergartner_participation_average(district_name)
    state_name = params[:against]
    state_average = calculate_kindergartner_participation_average(state_name)
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
      if state_value.nil?
        "Invalid data"
      elsif state_value == 0
        [year, 0.0]
      else
        [year,truncate(value/state_value)]
      end
    end.to_h
  end

  def kindergarten_participation_correlates_with_high_school_graduation(params)
    if params.has_key?(:for)
       district_name = params[:for]
       if district_name.upcase == "STATEWIDE"
         statewide_correlated?(kindergarten_high_school_correlation_statewide(district_name))
       else
        correlated?(kindergarten_high_school_correlation(district_name))
      end
    else
      districts = params[:across]

    end
  end

  def statewide_correlated?(num)
    num >= 0.70
  end

  def kindergarten_high_school_correlation_statewide(district_name)
    all_states = @dr.districts.map { |district| district.name}
    num_passing_schools = all_states.count { |district_name| correlated?(kindergarten_high_school_correlation(district_name))}
    state_verification = num_passing_schools.to_f/all_states.length.to_f
  end

  def kindergarten_high_school_correlation(district_name)
    kinder = kindergarten_participation_average(district_name)
    high_school = high_school_participation_average(district_name)
    verification = sanitize_data(kinder / high_school)
  end

  def correlated?(num)
    binding.pry if String === num

    num >= 0.6  && num <= 1.5
  end

  def kindergarten_participation_against_high_school_graduation(district_name)
    numerator = kindergarten_participation_average(district_name)
    denominator = high_school_participation_average(district_name)
    truncate(numerator / denominator)
  end

  def kindergarten_participation_average(district_name)
    district = @dr.find_by_name(district_name)
    kinder_average = district.enrollment.kindergarten_participation_by_year
    k = compute_average_from_participation_hash(kinder_average)
    kinder_participation = k/kindergarten_statewide_average

  end

  def high_school_participation_average(district_name)
      district = @dr.find_by_name(district_name)
    high_school = district.enrollment.graduation_rate_by_year
    h = compute_average_from_participation_hash(high_school)
    graduation_variation = h/high_school_statewide_average
  end

  def kindergarten_statewide_average
    calculate_kindergartner_participation_average("Colorado")
  end

  def high_school_statewide_average
    calculate_high_school_participation_average("Colorado")
  end

  ########################################################


  def top_statewide_test_year_over_year_growth(data)
    grade = sanitize_grade(data[:grade])
    subject = data[:subject]
    weighting = data[:weighting]

    check_for_insufficient_info_and_grade(data)
    grade_data = @sr.get_grade_data(grade)

    # district_subject_data = @sr.statewide_tests.map{|swt|
    #   [swt.name,grade_data.fetch(swt.name,"")]
    # }.to_h

    #grade_data.each_with_object { |subject, years| subject}
    if subject.nil?
      #all subjects
      grade_data.flat_map{|district,subjects| subjects.map{|subject,subject_data|
         [district,[[subject,compute_state_wide_year_over_year_growth(subject_data)]].to_h]}}.group_by{|k,v| k}

    else
      #single subject
      subject_data = grade_data.map{|district,data|
        [district,compute_state_wide_year_over_year_growth(data[subject])] if data[subject]
      }.to_h
      binding.pry
    end

  end

  def compute_state_wide_year_over_year_growth(subject_data)
    max_year = sanitize_data(subject_data.fetch(subject_data.keys.max))
    min_year = sanitize_data(subject_data.fetch(subject_data.keys.min))
    num_of_years = subject_data.length
    # binding.pry if String === max_year || String === min_year
    truncate((max_year - min_year) / num_of_years)
  end

# Where 0.123 is their average percentage growth across years. If there are
# three years of proficiency data (year1, year2, year3), that's
# ((proficiency at year3) - (proficiency at year1)) / (year3 - year1)
  def check_for_insufficient_info_and_grade(data)
    raise InsufficientInformationError,"A grade must be provided to answer this question" if data[:grade].nil?
    raise UnknownDataError,"#{:grade} is not a known grade" unless data[:grade] == 3 || data[:grade] == 8
  end

end
# dr = DistrictRepository.new
# dr.load_data({:enrollment => {:kindergarten => "./data/sample_kindergartners_file.csv"}})
# ha = HeadcountAnalyst.new(dr)
# p ha.kindergarten_participation_rate_variation('ACADEMY 20', against: 'Colorado')
