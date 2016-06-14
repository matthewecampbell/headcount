require_relative 'test_helper'
require_relative '../lib/district'
require_relative '../lib/district_repository'

class DistrictTest < Minitest::Test

  def test_it_returns_an_upcase_string_name
    d = District.new({:name => "aCADEMY 20"})
    assert_equal "ACADEMY 20", d.name
  end

  def test_it_can_get_kindergarten_partcipation_in_year
    dr = DistrictRepository.new
    dr.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv"
          }
        })
    district = dr.find_by_name("ACADEMY 20")
    assert_equal 0.436, district.enrollment.kindergarten_participation_in_year(2010)
  end

  def test_it_can_get_kindergarten_partcipation_in_year
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      },
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
      })
      district = dr.find_by_name("ACADEMY 20")
      assert_instance_of EconomicProfile, district.economic_profile
  end

end
