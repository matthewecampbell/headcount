require_relative 'test_helper'
require_relative '../lib/result_set'

class ResultSetTest < Minitest::Test
  attr_reader :r1, :r2, :rs

   def setup
     @r1 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.5,
         children_in_poverty_rate: 0.25,
         high_school_graduation_rate: 0.75})
     @r2 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.3,
         children_in_poverty_rate: 0.2,
         high_school_graduation_rate: 0.6})

     @rs = ResultSet.new(matching_districts: [r1], statewide_average: r2)
   end

   def test_matching_districts
     results = {:free_and_reduced_price_lunch_rate=>0.5, :children_in_poverty_rate=>0.25, :high_school_graduation_rate=>0.75}
     assert_equal results, rs.matching_districts[0].attributes
   end

   def test_statewide_average
     results = {:free_and_reduced_price_lunch_rate=>0.3, :children_in_poverty_rate=>0.2, :high_school_graduation_rate=>0.6}
     assert_equal results, rs.statewide_average.attributes
   end

   def test_free_and_reduced_price_lunch
     assert_equal 0.5, rs.matching_districts.first.free_and_reduced_price_lunch_rate
   end

   def test_children_in_poverty_rate_statewide
     assert_equal 0.2, rs.statewide_average.children_in_poverty_rate
   end

   def test_high_school_graduation_rate_statewide
     assert_equal 0.6, rs.statewide_average.high_school_graduation_rate
   end
end
