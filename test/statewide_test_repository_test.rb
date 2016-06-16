require_relative 'test_helper'
require_relative '../lib/statewide_test_repository'


class StatewideRepositoryTest < Minitest::Test
  attr_reader :str

  def setup
    @str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
  end

  def test_it_can_find_by_name
    st = str.find_by_name("ACADEMY 20")

    assert_instance_of StatewideTest, st
  end

  def test_it_loads_files_correctly
    result = {:math=>0.706, :reading=>0.698, :writing=>0.504}

    assert_equal result, str.statewide_tests["COLORADO"].attributes[:third_grade][2010]
    assert_instance_of StatewideTest, str.statewide_tests["AKRON R-1"]
    assert_equal 3, str.statewide_tests["AKRON R-1"].attributes[:eighth_grade][2008].count
    assert_equal ({:math=>0.552, :reading=>0.828, :writing=>0.3}), str.statewide_tests["AKRON R-1"].attributes[:eighth_grade][2008]

    assert_equal (11), str.statewide_tests["AKRON R-1"].attributes.keys.count
    assert_equal :name, str.statewide_tests["AKRON R-1"].attributes.keys.first
    assert_equal :white, str.statewide_tests["AKRON R-1"].attributes.keys.last

    assert_equal 4, str.statewide_tests["AKRON R-1"].attributes[:white].keys.count
    assert_equal 2011, str.statewide_tests["AKRON R-1"].attributes[:white].keys.first
    assert_equal 2014, str.statewide_tests["AKRON R-1"].attributes[:white].keys.last

    assert_equal 4, str.statewide_tests["AKRON R-1"].attributes[:white].values.count
    assert_equal ({:math=>0.494, :reading=>0.769, :writing=>0.601}), str.statewide_tests["AKRON R-1"].attributes[:white].values.first
    assert_equal ({:math=>0.496, :reading=>0.007, :writing=>0.515}), str.statewide_tests["AKRON R-1"].attributes[:white].values.last

  end
end
