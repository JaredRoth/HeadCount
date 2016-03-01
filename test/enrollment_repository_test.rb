require './test/test_helper'


class EnrollmentRepositoryTest < Minitest::Test


  def test_can_find_by_school_name
    er = EnrollmentRepository.new
   (location: "Turing", timeframe: "2015", dataformat: "Percent", data:"0.2222")
    })

    assert_equal "ACADEMY 20", er.find_by_name("Academy 20").location
  end
end
