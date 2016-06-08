require './test/test_helper'
require './lib/district_repository'
require './lib/district'

class DistrictRepositoryTest < Minitest::Test

  def test_it_loads_data_by_length
    dr = DistrictRepository.new
    dr.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv"
          }
        })
    district = dr.find_by_name("ACADEMY 20")
    assert_instance_of District, district
  end

  def test_it_can_find_by_name
    d1 = District.new({:name => "Adams"})
    d2 = District.new({:name => "ACADEMY 20"})
    dr = DistrictRepository.new([d1, d2])

    assert_equal d1, dr.find_by_name("Adams")
    assert_equal d2, dr.find_by_name("ACADEMY 20")
  end

  def test_find_by_name_returns_nil
    d1 = District.new({:name => "Adams"})
    d2 = District.new({:name => "ACADEMY 20"})
    dr = DistrictRepository.new([d1, d2])

    assert_equal nil, dr.find_by_name("Not_a_name")
  end

  def test_find_by_name_by_fragment
    d1 = District.new({:name => "Adams"})
    d2 = District.new({:name => "ACADEMY 20"})
    dr = DistrictRepository.new([d1, d2])

    assert_equal [d1, d2], dr.find_all_matching("A")
  end

end
