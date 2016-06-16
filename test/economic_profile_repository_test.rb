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

  def test_it_loads_files_correctly
    result = {:total=>279275, :percentage=>0.068}

    assert_equal result, epr.economic_profiles["COLORADO"].attributes[:free_or_reduced_price_lunch][2010]
    assert_instance_of EconomicProfile, epr.economic_profiles["AKRON R-1"]
    assert_equal 5, epr.economic_profiles["AKRON R-1"].attributes.count

    assert_equal ({[2005, 2009]=>37945, [2006, 2010]=>38525, [2008, 2012]=>40741,
       [2007, 2011]=>42635, [2009, 2013]=>43906}), epr.economic_profiles["AKRON R-1"].attributes[:median_household_income]

    assert_equal ([:name, :median_household_income, :children_in_poverty,
      :free_or_reduced_price_lunch, :title_i]), epr.economic_profiles["AKRON R-1"].attributes.keys


    assert_equal (1995), epr.economic_profiles["AKRON R-1"].attributes[:children_in_poverty].keys.first
    assert_equal (2013), epr.economic_profiles["AKRON R-1"].attributes[:children_in_poverty].keys.last

    assert_equal ({:percentage=>0.185}), epr.economic_profiles["AKRON R-1"].attributes[:children_in_poverty].values.first
    assert_equal ({:total=>61, :percentage=>0.161}), epr.economic_profiles["AKRON R-1"].attributes[:children_in_poverty].values.last
  end
end
