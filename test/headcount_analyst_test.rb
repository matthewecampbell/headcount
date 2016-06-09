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

    assert_equal ({2009 => 0.652, 2010 => 0.681, 2011 => 0.728}), ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
  end
end
