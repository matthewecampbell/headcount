require_relative 'test_helper'
require_relative '../lib/calc'

class CalcTest < Minitest::Test
  include Calc

  def test_it_truncates_float
    expected = 0.098
    assert_equal expected, truncate_float(0.0987654321)
  end

  def test_it_is_not_a_number
    expected = -1.0
    assert_equal expected, truncate_float(-1.0)
  end
end
