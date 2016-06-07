require './test/test_helper'
require './lib/district_repo'

class DistrictRepoTest < Minitest::Test

  def test_it_loads_data_by_length
    dr = DistrictRepo.new
    dr.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv"
          }
        })
    assert_equal 181, dr.districts.uniq.length
  end

  def test_it_loads_data_by_checking_first
    dr = DistrictRepo.new
    dr.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv"
          }
        })
    assert_equal "Colorado", dr.districts.uniq.first
  end

  def test_it_can_find_by_name
    skip
    dr = DistrictRepo.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
        }
      })
      district = dr.find_by_name("ACADEMY 20")
      assert_equal "<District>", district
  end

end
