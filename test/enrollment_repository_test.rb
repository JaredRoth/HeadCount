require './test/test_helper'


class EnrollmentRepositoryTest < Minitest::Test

  def setup
    @er = EnrollmentRepository.new
    @er.load_data({:enrollment => {:kindergarten => "./data/sample_kindergartners_file.csv"}})
  end

  def test_can_load_all_data
    assert_equal 7, @er.enrollments.length
  end

  def test_can_load_single_data
    result = @er.find_by_name("ADAMS-ARAPAHOE 28J")

    assert_equal "ADAMS-ARAPAHOE 28J", result.name
  end

  def test_find_by_name_returns_enrollment_object
    result = @er.find_by_name("ADAMS-ARAPAHOE 28J")
    e = {"2007"=>0.473,
      "2006"=>0.37,
      "2005"=>0.201,
      "2004"=>0.174,
      "2008"=>0.479,
      "2009"=>0.73,
      "2010"=>0.922,
      "2011"=>0.95,
      "2012"=>0.973,
      "2013"=>0.976,
      "2014"=>0.971}

    assert_equal e, result.kindergarten_participation
  end

  def test_does_not_load_duplicate_data
    @er.enrollments.each do |enrollment|
      assert @er.enrollments.one?{|en| en.name == enrollment.name}
    end
  end

  # def test_value_for_specific_year_is_correct
  #   e = @er.enrollments.find { |enroll| enroll.name == "ACADEMY 20"}
  #
  #   assert_equal 0.436, e.kindergarten_participation_in_year(2010)
  # end

  def test_enrollment_creates_array_of_enrollments
    refute @er.enrollments.nil?
    assert_equal 7, @er.enrollments.length
  end

  def test_enrollment_contains_merged_data
    result = @er.enrollments.find { |enroll| enroll.name == "ACADEMY 20"}

    e = {"2007"=>0.0,
   "2006"=>0.353,
   "2005"=>0.267,
   "2004"=>0.302,
   "2008"=>0.384,
   "2009"=>0.39,
   "2010"=>0.436,
   "2011"=>0.489,
   "2012"=>0.478,
   "2013"=>0.487,
   "2014"=>0.49}

    assert_equal e, result.kindergarten_participation
  end
end
