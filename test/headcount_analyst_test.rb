require 'pry'
require_relative '../test/test_helper'
require_relative '../lib/headcount_analyst'
require_relative '../lib/district_repository'
require_relative '../lib/enrollment'
require_relative '../lib/district'

class HeadcountAnalystTest < Minitest::Test

  def test_kindergarten_participation_rate_variation_against_state
    dr = DistrictRepository.new
    dr.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv"
          }
        })
    ha = HeadcountAnalyst.new(dr)

    assert_equal 0.766, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  end

  def test_kindergarten_participation_rate_variation_against_county
    dr = DistrictRepository.new
    dr.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv"
          }
        })
    ha = HeadcountAnalyst.new(dr)

    assert_equal 0.447, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')
  end

  def test_kindergarten_participation_rate_variation_trend
    dr = DistrictRepository.new
    dr.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv"
          }
        })
    ha = HeadcountAnalyst.new(dr)

    assert_equal ({2004=>1.257, 2005=>0.96, 2006=>1.05, 2007=>0.992, 2008=>0.717, 2009=>0.652, 2010=>0.681, 2011=>0.727, 2012=>0.688, 2013=>0.694, 2014=>0.661}), ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
  end

  def test_high_school_graduation_rate_variation_against_state
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
      })
      ha = HeadcountAnalyst.new(dr)

      assert_equal 0.641, ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')
  end


  def test_kindergarten_participation_correlates_with_high_school_graduation_for_district
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
      })
      ha = HeadcountAnalyst.new(dr)

      assert ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'ACADEMY 20')
    end

    def test_kindergarten_participation_correlates_with_high_school_graduation_statewide

      dr = DistrictRepository.new
      dr.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv",
          :high_school_graduation => "./data/High school graduation rates.csv"
        }
        })
        ha = HeadcountAnalyst.new(dr)

      refute ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'STATEWIDE')
    end

    def test_can_get_all_district_names
      dr = DistrictRepository.new
      dr.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv",
          :high_school_graduation => "./data/High school graduation rates.csv"
        }
        })
        ha = HeadcountAnalyst.new(dr)

        assert_equal ["COLORADO", "ACADEMY 20", "ADAMS COUNTY 14"], dr.get_all_district_names[0..2]
        assert_equal 181, dr.get_all_district_names.count
      end

    def test_can_get_subset_district_names
      dr = DistrictRepository.new
      dr.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv",
          :high_school_graduation => "./data/High school graduation rates.csv"
        }
        })
        ha = HeadcountAnalyst.new(dr)

        refute  ha.kindergarten_participation_correlates_with_high_school_graduation(
        :across => ['ACADEMY 20', 'PUEBLO CITY 60', 'AGATE 300', 'ADAMS COUNTY 14'])
      end

end
