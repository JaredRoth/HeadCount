require_relative 'test_helper'
require_relative '../lib/module_helper'

class HelperTest < Minitest::Test

  include Helper

  def test_floats_and_intergers_can_be_truncated
    assert_equal 0.719, truncate(0.7193294)
  end

  def test_sanitize_removes_spaces_from_numbers_with_extra_spaces
    assert_equal 0.718, sanitize_data("0 .718329")
  end

  def test_numeric_string_converts_to_numeric_float
    assert_equal 0.712, sanitize_data("0 .712329")
  end

  def test_sanitize_data_to_NA
    assert_equal "N/A", sanitize_data_to_na(0)
  end

  def test_error_is_raised_unless_condition_is_met
    assert UnknownDataError do error?(false)
    end
  end

  def test_percentage_gets_truncated

    assert_equal [0.074], truncate_percentages({"2008" => 0.07431323}).values
    assert_equal ["2008"], truncate_percentages({"2008" => 0.07431323}).keys
  end

  def test_sanitze_grade_allow_valid_grade_only
    assert_equal nil, sanitize_grade(9)
    assert_equal (:third_grade), sanitize_grade(3)
  end

end
