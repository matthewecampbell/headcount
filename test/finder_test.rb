require_relative 'test_helper'
require_relative '../lib/finder'
require_relative '../lib/statewide_test'
require_relative '../lib/statewide_test_repository'

class FinderTest < Minitest::Test
  include Finder
  attr_reader :data, :str, :st

  def setup
    @data = {
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    }

    @str = StatewideTestRepository.new
    str.load_data(data)
    @st = str.find_by_name("ACADEMY 20")
  end

  def test_grade_level_exists
    assert_equal :eighth_grade, st.grade_level_exists(8)
  end

  def test_race_exists
    expected = ({2011=>{:math=>0.816, :reading=>0.897, :writing=>0.826}, 2012=>{:math=>0.818, :reading=>0.893, :writing=>0.808}, 2013=>{:math=>0.805, :reading=>0.901, :writing=>0.81}, 2014=>{:math=>0.8, :reading=>0.855, :writing=>0.789}})
    assert_equal expected, st.race_exists(:asian)
  end

  def test_incorrect_race_returns_nil
    assert_equal nil, st.race_exists(:martian)
  end

  def test_find_proficient_by_race_or_ethnicity
    expected = {2011=>{:math=>0.706, :reading=>0.851, :writing=>0.74}, 2012=>{:math=>0.713, :reading=>0.861, :writing=>0.726}, 2013=>{:math=>0.72, :reading=>0.86, :writing=>0.74}, 2014=>{:math=>0.723, :reading=>0.008, :writing=>0.734}}
    assert_equal expected, st.find_proficient_by_race_or_ethinicity(:white)
  end

  def test_year_exists
    expected = ({:math=>0.824, :reading=>0.862, :writing=>0.706})
    assert_equal expected, st.year_exists(:math, 3, 2009)
  end

  def test_subject_exists_in_year_and_grade
    expected = 0.824
    assert_equal expected, st.subject_exists_in_year_and_grade(:math, 3, 2009)
  end

  def test_find_proficient_by_subject_by_grade_in_year
    expected = 0.825
    assert_equal expected, st.find_proficient_by_subject_by_grade_in_year(:reading, 8 , 2009)
  end

  def test_subject_exists_in_year_and_race
    expected = 0.826
    assert_equal expected, st.subject_exists_in_year_and_race(:writing, :asian, 2011)
  end

  def test_find_proficient_by_subject_by_race_in_year
    expected = 0.826
    assert_equal expected, st.find_proficient_by_subject_by_race_in_year(:writing, :asian, 2011)
  end
end
