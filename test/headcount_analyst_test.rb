  require_relative '../test/test_helper'
require_relative '../lib/headcount_analyst'
require_relative '../lib/district_repository'
require_relative '../lib/enrollment'
require_relative '../lib/district'

class HeadcountAnalystTest < Minitest::Test
  attr_reader :dr,
              :ha

  def setup
    @dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      },
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })
    @ha = HeadcountAnalyst.new(dr)
  end

  def test_kindergarten_participation_rate_variation_against_state
    assert_equal 0.766, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  end

  def test_kindergarten_participation_rate_variation_against_county
    assert_equal 0.447, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')
  end

  def test_kindergarten_participation_rate_variation_trend
    assert_equal ({2004=>1.257, 2005=>0.96, 2006=>1.05, 2007=>0.992, 2008=>0.717, 2009=>0.652, 2010=>0.681, 2011=>0.727, 2012=>0.688, 2013=>0.694, 2014=>0.661}), ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
  end

  def test_high_school_graduation_rate_variation_against_state
      assert_equal 0.641, ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')
  end


  def test_kindergarten_participation_correlates_with_high_school_graduation_for_district
    assert ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'ACADEMY 20')
  end

  def test_kindergarten_participation_correlates_with_high_school_graduation_statewide
    ha.make_results("ACADEMY 20", results = [])
    assert_instance_of Array, ha.make_results("ACADEMY 20", results = [])
    assert ha.tally_results(results)
    refute ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'STATEWIDE')
  end

  def test_can_get_all_district_names
      assert_equal ["COLORADO", "ACADEMY 20", "ADAMS COUNTY 14"], dr.get_all_district_names[0..2]
      assert_equal 181, dr.get_all_district_names.count
    end

  def test_can_get_subset_district_names
      refute ha.kindergarten_participation_correlates_with_high_school_graduation(
      :across => ['ACADEMY 20', 'PUEBLO CITY 60', 'AGATE 300', 'ADAMS COUNTY 14'])
  end

  def test_high_poverty_and_high_school_graduation
    dist = dr.find_by_name("ACADEMY 20")

    rs = ha.high_poverty_and_high_school_graduation
    assert_instance_of ResultSet, rs
    assert_instance_of Array, rs.matching_districts
    assert_equal 46, rs.matching_districts.count
    rs1 = ha.high_income_disparity
    assert_instance_of ResultSet, rs1
    refute ha.high_poverty_and_grad_check("ACADEMY 20")
    refute ha.students_qualifying_for_lunch?(dist)
    refute ha.children_in_poverty?(dist)
    assert ha.graduation_rate?(dist)
  end

  def test_high_income_disparity
    dist = dr.find_by_name("ACADEMY 20")
    md = "matching_districts"

    assert_equal 2, ha.high_income_disparity.matching_districts.count
    assert ha.median_household_income?(dist)
    assert_equal 57408, ha.statewide_average_income
    refute ha.children_in_poverty?(dist)
    assert_instance_of Array, ha.statewide_poverty_percentages("WOODLAND PARK RE-2", percentages = [])
    assert_equal 0.165, ha.statewide_poverty
    assert_instance_of ResultSet, ha.high_income_disparity_result(md)
  end

  def test_free_and_reduced_price_lunch_data
    dist = dr.find_by_name("ACADEMY 20")
    refute ha.students_qualifying_for_lunch?(dist)
    assert_equal 0.242, ha.statewide_average_lunch
    assert_instance_of Array, ha.statewide_lunch_percentages("ACADEMY 20", percentages = [])
  end

  def test_kindergarten_participation_against_household_income
    dist = dr.find_by_name("ACADEMY 20")

    assert ha.median_household_income?(dist)
    assert_equal 1.526, ha.kindergarten_participation_against_household_income("ACADEMY 20")
  end
end
