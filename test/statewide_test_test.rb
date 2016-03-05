require_relative 'test_helper'
require_relative '../lib/statewide_test'
require_relative '../lib/district_repository'

class StatewideTestTest < Minitest::Test
  def setup
    str = StatewideTestRepository.new
    str.load_data({
                    :statewide_testing => {
                      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                    }
                  })

    @st = str.find_by_name("ACADEMY 20")
  end

  def test_truncates_to_3_digits
    result = @st.truncate(0.3847528305)

    assert_equal 0.384, result
  end

  def test_truncates_hash
    result = @st.truncate_percentages({2010 => 0.391143, 2011 => 0.353234, 2012 => 0.267234})
    nk = {2010 => 0.391, 2011 => 0.353, 2012 => 0.267}

    assert_equal nk, result
  end

  def test_enrollment_provides_name_for_district
    assert_equal "ACADEMY 20", @st.name
  end

  def test_proficient_by_grade_returns_UnknownDataError
    assert_raises UnknownDataError do
      @st.proficient_by_grade(9)
    end
  end

  def test_proficient_by_grade_returns_correct_data_in_correct_format
    third = {2008 => {math: 0.857, reading: 0.866, writing: 0.671},
             2009 => {math: 0.824, reading: 0.862, writing: 0.706},
             2010 => {math: 0.849, reading: 0.864, writing: 0.662},
             2011 => {math: 0.819, reading: 0.867, writing: 0.678},
             2012 => {math: 0.83,  reading: 0.87,  writing: 0.655},
             2013 => {math: 0.855, reading: 0.859, writing: 0.668},
             2014 => {math: 0.834, reading: 0.831, writing: 0.639}}

    eighth = {2008 => {math: 0.64,  reading: 0.843, writing: 0.734},
              2009 => {math: 0.656, reading: 0.825, writing: 0.701},
              2010 => {math: 0.672, reading: 0.863, writing: 0.754},
              2011 => {math: 0.653, reading: 0.832, writing: 0.745},
              2012 => {math: 0.681, reading: 0.833, writing: 0.738},
              2013 => {math: 0.661, reading: 0.852, writing: 0.750},
              2014 => {math: 0.684, reading: 0.827, writing: 0.747}}

    assert_equal third, @st.proficient_by_grade(3)
    assert_equal eighth, @st.proficient_by_grade(8)
  end

  def test_proficient_by_race_or_ethnicity_returns_UnknownRaceError
    assert_raises UnknownDataError do
      @st.proficient_by_race_or_ethnicity(:pizza)
    end
    assert_raises UnknownDataError do
      @st.proficient_by_race_or_ethnicity(:all_students)
    end
  end

  def test_proficient_by_race_or_ethnicity_returns_correct_data_in_correct_format
    asian = {2011=>{:math=>0.816, :reading=>0.897, :writing=>0.826},
             2012=>{:math=>0.818, :reading=>0.893, :writing=>0.808},
             2013=>{:math=>0.805, :reading=>0.901, :writing=>0.81},
             2014=>{:math=>0.8,   :reading=>0.855, :writing=>0.789}}

    black = {2011=>{:math=>0.424, :reading=>0.662, :writing=>0.515},
             2012=>{:math=>0.424, :reading=>0.694, :writing=>0.504},
             2013=>{:math=>0.44,  :reading=>0.669, :writing=>0.481},
             2014=>{:math=>0.42,  :reading=>0.703, :writing=>0.519}}

    assert_equal asian, @st.proficient_by_race_or_ethnicity(:asian)
    assert_equal black, @st.proficient_by_race_or_ethnicity(:black)
  end

  def test_subject_by_grade_in_year_returns_UnknownDataError
    assert_raises UnknownDataError do
      @st.proficient_for_subject_by_grade_in_year(:pizza, 3, 2010)
    end
    assert_raises UnknownDataError do
      @st.proficient_for_subject_by_grade_in_year(:math, 4, 2010)
    end
    assert_raises UnknownDataError do
      @st.proficient_for_subject_by_grade_in_year(:math, 3, 2030)
    end
  end

  def test_subject_by_grade_in_year_returns_correct_data_in_correct_format
    assert_equal 0.857, @st.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
  end

  def test_subject_by_race_in_year_returns_UnknownDataError
    assert_raises UnknownDataError do
      @st.proficient_for_subject_by_race_in_year(:pizza, :asian, 2012)
    end
    assert_raises UnknownDataError do
      @st.proficient_for_subject_by_race_in_year(:math, :pizza, 2012)
    end
    assert_raises UnknownDataError do
      @st.proficient_for_subject_by_race_in_year(:math, :asian, 2030)
    end
  end

  def test_subject_by_race_in_year_returns_correct_data_in_correct_format
    assert_equal 0.818, @st.proficient_for_subject_by_race_in_year(:math, :asian, 2012)
  end
end
