require_relative 'test_helper'
require_relative '../lib/district'

class DistrictTest < Minitest::Test

  def test_it_returns_an_upcase_string_name
    d = District.new({:name => "aCADEMY 20"})
    assert_equal "ACADEMY 20", d.name
  end

end
