require_relative 'test_helper'
require_relative '../lib/economic_profile_repository'
require_relative '../lib/result_set'

class EconomicProfileRepositoryTest < Minitest::Test
  attr_reader :epr

  def setup
    @epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })
  end

  def test_it_can_find_by_name
    ep = epr.find_by_name("ACADEMY 20")

    assert_instance_of EconomicProfile, ep
  end

  def test_it_loads_files
    result = {:total=>279275, :percentage=>0.068}

    assert_equal result, epr.economic_profiles["COLORADO"].attributes[:free_or_reduced_price_lunch][2010]
  end
end
