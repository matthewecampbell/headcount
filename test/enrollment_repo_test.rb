require './test/test_helper'
require './lib/enrollment_repo'
require './lib/enrollment'

class EnrollmentRepoTest < Minitest::Test

  def test_it_can_load_data_and_find_name
  er = EnrollmentRepo.new
  er.load_data({
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    enrollment = er.find_by_name("ACADEMY 20")
    assert_instance_of Enrollment, enrollment
  end

  def test_it_can_find_by_name
    e1 = Enrollment.new({:name => "Adams"})
    e2 = Enrollment.new({:name => "ACADEMY 20"})
    er = EnrollmentRepo.new([e1, e2])

    assert_equal e1, er.find_by_name("Adams")
    assert_equal e2, er.find_by_name("ACADEMY 20")
  end

  def test_find_by_name_returns_nil
    e1 = Enrollment.new({:name => "Adams"})
    e2 = Enrollment.new({:name => "ACADEMY 20"})
    er = EnrollmentRepo.new([e1, e2])

    assert_equal nil, er.find_by_name("Name_not_found")
  end

end
