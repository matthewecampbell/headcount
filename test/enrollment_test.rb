require_relative 'test_helper'
require_relative '../lib/enrollment'

class EnrollmentTest < Minitest::Test
  attr_reader :enrollment

  def setup
    @enrollment = Enrollment.new({
      :name => "ACADEMY 20",
        :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677},
          :high_school_graduation => {2010 => 0.895, 2011 => 0.895, 2012 => 0.889, 2013 => 0.913, 2014 => 0.898}
    })
  end

  def test_kindergarten_participation_by_year
    expected = {  2010 => 0.391, 2011 => 0.353, 2012 => 0.267  }
    assert_equal expected, enrollment.kindergarten_participation_by_year
  end

  def test_kindergarten_participation_in_year
    expected = 0.391
    assert_equal expected, enrollment.kindergarten_participation_in_year(2010)
  end

  def test_it_returns_kindergarten_participation
    expected = {2010=>0.3915, 2011=>0.35356, 2012=>0.2677}
    assert_equal expected, enrollment.kindergarten_participation
  end

  def test_graduation_rate_by_year
    expected = { 2010 => 0.895,2011 => 0.895, 2012 => 0.889, 2013 => 0.913, 2014 => 0.898 }
    assert_equal expected, enrollment.graduation_rate_by_year
  end

  def test_graduation_rate_in_year
    expected = 0.895
    assert_equal expected, enrollment.graduation_rate_in_year(2010)
  end

  def test_it_returns_high_school_graduation
    expected = {2010=>0.895, 2011=>0.895, 2012=>0.889, 2013=>0.913, 2014=>0.898}
    assert_equal expected, enrollment.high_school_graduation
  end

  def test_high_school_graduation_exists
    assert enrollment.high_school_graduation_data_exists?
  end

end
