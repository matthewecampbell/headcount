require_relative 'test_helper'
require_relative '../lib/finder'
require_relative '../lib/enrollment_repository'
require_relative '../lib/enrollment'

class DataParserTest < Minitest::Test
  attr_reader :er

  def setup
    @er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
    })
    enrollment = er.find_by_name("ACADEMY 20")
  end

  def test_find_name
    assert_equal "ACADEMY 20", er.find_name({location:"ACADEMY 20", timeframe:"2007", dataformat:"Percent", data:"0.39465"})
  end

  def test_sub_grade
    assert_equal :math, er.find_sub_grade({location:"ACADEMY 20", timeframe:"2007", dataformat:"Percent", data:"0.39465", score: "Math"})
  end

  def test_find_year
    assert_equal 2007, er.find_year({location:"ACADEMY 20", timeframe:"2007", dataformat:"Percent", data:"0.39465", score: "Math"})
  end

  def test_find_year_collection
    assert_equal [2009, 2013], er.find_year_collection({location:"ACADEMY 20", timeframe:"2009-2013", dataformat:"Percent", data:"0.39465", score: "Math"})
  end

  def test_find_data_format
    assert_equal :percentage, er.find_data_format({location:"ACADEMY 20", timeframe:"2009-2013", dataformat:"Percent", data:"0.39465", score: "Math"})
  end

  def test_find_number
    assert_equal 0.39465, er.find_number({location:"ACADEMY 20", timeframe:"2009-2013", dataformat:"Percent", data:"0.39465", score: "Math"}, :percentage)
  end

  def test_find_enrollment_percentage
    assert_equal 0.39465, er.find_enrollment_percent({location:"ACADEMY 20", timeframe:"2009-2013", dataformat:"Percent", data:"0.39465", score: "Math"})
  end

  def test_find_percent_n_a
    assert_equal "N/A", er.find_percent({location:"ACADEMY 20", timeframe:"2009-2013", dataformat:"Percent", data:"N/A", score: "Math"})
  end

  def test_find_income
    assert_equal 36521, er.find_income({location:"ACADEMY 20", timeframe:"2009-2013", dataformat:"Percent", data:"36521", score: "Math"})
  end
end
