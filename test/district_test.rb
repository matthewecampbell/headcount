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
    assert_equal 0.391, district.enrollment.kindergarten_participation_in_year(2010)
  end

end
