require './test/test_helper'
require './lib/district_repo'
require './lib/district'

class DistrictRepoTest < Minitest::Test

  def test_it_loads_data_by_length
    skip
    dr = DistrictRepo.new
    dr.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv"
          }
        })
    assert_equal 181, dr.districts.uniq.length
  end

  def test_it_can_find_by_name
    d1 = District.new({:name => "Adams"})
    d2 = District.new({:name => "ACADEMY 20"})
    dr = DistrictRepo.new([d1, d2])

    assert_equal "Adams", dr.find_by_name("Adams").attributes[:name]
    assert_equal "ACADEMY 20", dr.find_by_name("ACADEMY 20").attributes[:name]
  end

  def test_find_by_name_returns_nil
    d1 = District.new({:name => "Adams"})
    d2 = District.new({:name => "ACADEMY 20"})
    dr = DistrictRepo.new([d1, d2])

    assert_equal nil, dr.find_by_name("Not_a_name")
  end


end
