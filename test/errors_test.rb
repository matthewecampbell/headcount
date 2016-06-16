require_relative 'test_helper'
require_relative '../lib/errors'

class ErrorsTest < Minitest::Test

  def test_it_has_unkown_data_error
    assert_raises(UnknownDataError) do
      raise UnknownDataError
    end
  end

  def test_it_has_an_unknown_race_error
    assert_raises(UnknownRaceError) do
      raise UnknownRaceError
    end
  end

end
