require_relative 'test_helper'
require_relative '../lib/district'
require_relative '../lib/district_repository'

class DistrictTest < Minitest::Test
  attr_reader :data

  def setup
    @data = {
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      },
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      },
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    }
  end

  def test_it_returns_an_upcase_string_name
    d = District.new({:name => "aCAdemy 20"})

    assert_equal "ACADEMY 20", d.name
  end

  def test_it_can_get_kindergarten_partcipation_in_year
    dr = DistrictRepository.new
    dr.load_data(data)
    district = dr.find_by_name("ACADEMY 20")

    assert_equal 0.436, district.enrollment.kindergarten_participation_in_year(2010)
  end

  def test_it_can_get_an_instance_of_enrollment
    dr = DistrictRepository.new
    dr.load_data(data)
    district = dr.find_by_name("ACADEMY 20")

    assert_instance_of Enrollment, district.enrollment
  end

  def test_it_can_confirm_enrollment_data
    dr = DistrictRepository.new
    dr.load_data(data)
    district = dr.find_by_name("WOODLAND PARK RE-2")

    expected = 1.0
    assert_equal expected, district.enrollment.attributes[:kindergarten_participation][2009]
  end

  def test_it_can_get_an_instance_of_statewide_test
    dr = DistrictRepository.new
    dr.load_data(data)
    district = dr.find_by_name("ACADEMY 20")

    assert_instance_of StatewideTest, district.statewide_test
  end

  def test_it_can_confirm_statewide_test_data
    dr = DistrictRepository.new
    dr.load_data(data)
    district = dr.find_by_name("WOODLAND PARK RE-2")

    expected = {:math=>0.798, :reading=>0.838, :writing=>0.556}
    assert_equal expected, district.statewide_test.attributes[:third_grade][2008]
  end

  def test_it_can_get_an_instance_of_economic_profile
    dr = DistrictRepository.new
    dr.load_data(data)
    district = dr.find_by_name("ACADEMY 20")

    assert_instance_of EconomicProfile, district.economic_profile
  end

  def test_it_can_confirm_economic_profile_data
    dr = DistrictRepository.new
    dr.load_data(data)
    district = dr.find_by_name("WOODLAND PARK RE-2")

    expected = 0.091
    assert_equal expected, district.economic_profile.attributes[:children_in_poverty][1995][:percentage]
  end
end
