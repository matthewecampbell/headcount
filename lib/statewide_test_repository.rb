require 'pry'
require 'csv'
require_relative 'statewide_test'

class StatewideTestRepository
  attr_reader :statewide_tests, :test_categories

  def initialize(statewide_tests = {})
    @statewide_tests = statewide_tests
    @test_categories =   {
      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
     }
  end

  def load_data(data)
    data.values[0].values.each_with_index do |filepath, index|
    read_file(data, filepath, index)
    end
  end

  def read_file(data, filepath, index)
      CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
        binding.pry
        name = row[:location].upcase
        subject = row[:score].upcase
        year = row[:timeframe].to_i
        percent = row[:data].to_f
        test_category = test_categories[data.values[0].keys[index]]
        check_statewide_tests = find_by_name(name)
        if check_statewide_tests == nil
          statewide_tests[name] = StatewideTest.new({:name => name, test_category => {:subject => {year => percent}}})
        else
          add_test_category(check_statewide_tests, test_category, year, percent)
      end
    end
  end

  def add_test_category(statewide_test_object, test_category, year, percent)
    if grade == :kindergarten_participation
      enrollment_object.kindergarten_participation.merge!({year => percent})
    else
      enrollment_object.high_school_graduation.merge!({year => percent})
    end
  end

  def find_by_name(district_name)
    enrollments[district_name]
  end

end
