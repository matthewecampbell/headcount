require_relative 'test_helper'
require_relative '../lib/economic_profile'
require_relative '../lib/economic_profile_repository'
require_relative '../lib/errors'

class EconomicProfileTest < Minitest::Test
  attr_reader :epr,
              :ep

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
    @ep = epr.find_by_name("ACADEMY 20")
  end

  def test_median_household_income_in_year

    assert_equal 85060, ep.median_household_income_in_year(2005)
    assert_equal 87635, ep.median_household_income_in_year(2009)
  end

  def test_median_household_income_average
    assert_equal 87635, ep.median_household_income_average
  end

  def test_children_in_poverty_in_year
    assert_equal ({:total=>921, :percentage=>0.047}), ep.children_in_poverty_in_year(2009)
    assert_raises(UnknownDataError) do
      ep.children_in_poverty_in_year(2020)
    end
  end

  def test_free_or_reduced_price_lunch_percentage_in_year
    assert_equal 0.087, ep.free_or_reduced_price_lunch_percentage_in_year(2014)
    assert_raises(UnknownDataError) do
      ep.free_or_reduced_price_lunch_percentage_in_year(2020)
    end
  end

  def test_free_or_reduced_price_lunch_number_in_year
    assert_equal 976, ep.free_or_reduced_price_lunch_number_in_year(2014)
    assert_raises(UnknownDataError) do
      ep.free_or_reduced_price_lunch_number_in_year(2020)
    end
  end

  def test_title_i_in_year
    assert_equal 0.011, ep.title_i_in_year(2011)
    assert_raises(UnknownDataError) do
      ep.title_i_in_year(2020)
    end
  end
end
