require_relative 'test_helper'
require_relative '../lib/enrollment_repository'
require_relative '../lib/enrollment'

class EnrollmentRepositoryTest < Minitest::Test

  def test_it_can_load_data
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
    })
    enrollment = er.find_by_name("ACADEMY 20")
    assert_instance_of Enrollment, enrollment
  end

  def test_it_can_find_by_name
    e1 = Enrollment.new({:name => "Adams"})
    e2 = Enrollment.new({:name => "ACADEMY 20"})
    er = EnrollmentRepository.new({"Adams" => e1, "ACADEMY 20" => e2})

    assert_equal e1, er.find_by_name("Adams")
    assert_equal e2, er.find_by_name("ACADEMY 20")
  end

  def test_find_by_name_returns_nil
    e1 = Enrollment.new({:name => "Adams"})
    e2 = Enrollment.new({:name => "ACADEMY 20"})
    er = EnrollmentRepository.new({"Adams" => e1, "ACADEMY 20" => e2})

    assert_equal nil, er.find_by_name("Name_not_found")
  end

  def test_it_populates_enrollments
    e1 = Enrollment.new({:name => "Adams"})
    e2 = Enrollment.new({:name => "WOODLAND PARK RE-2"})
    er = EnrollmentRepository.new({"Adams" => e1, "WOODLAND PARK RE-2" => e2})

    assert_equal ["Adams", "WOODLAND PARK RE-2"], er.enrollments.keys
  end

  def test_enrollments_holds_enrollment_data
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
    })
    e1 = er.find_by_name("ACADEMY 20")
    e2 = er.find_by_name("WOODLAND PARK RE-2")


    assert_equal ([:name, :kindergarten_participation, :high_school_graduation]), e1.attributes.keys
    assert_equal "ACADEMY 20", e1.attributes.values.first
    assert_equal ({2010=>0.895, 2011=>0.895, 2012=>0.88983, 2013=>0.91373, 2014=>0.898}), e1.attributes.values.last
    assert_instance_of Hash, e1.attributes
    assert_equal 3, e1.attributes.count

    assert_equal ([:name, :kindergarten_participation, :high_school_graduation]), e2.attributes.keys
    assert_equal "WOODLAND PARK RE-2", e2.attributes.values.first
    assert_equal ({2010=>0.814, 2011=>0.852, 2012=>0.85837, 2013=>0.79911, 2014=>0.755}), e2.attributes.values.last
    assert_instance_of Hash, e2.attributes
    assert_equal 3, e2.attributes.count

  end

end
