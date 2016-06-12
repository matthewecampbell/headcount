require 'pry'
require 'csv'
require_relative 'statewide_test'

class StatewideTestRepository
  attr_reader :statewide_tests, :test_results

  def initialize(statewide_tests = {})
    @statewide_tests = statewide_tests
    @test_results =   {
      3 => :third_grade,
      8 => :eighth_grade,
     "ALL STUDENTS" => :all_students,
     "ASIAN" => :asian,
     "BLACK" => :black,
     "HAWAIIAN/PACIFIC ISLANDER" => :pacific_islander,
     "HISPANIC" => :hispanic,
     "NATIVE AMERICAN" => :native_american,
     "TWO OR MORE" => :two_or_more,
     "WHITE" => :white
      }
  end

  def load_data(data)
    data.values[0].values.each_with_index do |filepath, index|
    read_file(data, filepath, index)
    end
  end

  def read_file(data, filepath, index)
    check_loadpath(data, filepath, index)
  end

  def read_file_1(data, filepath, index)
    CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
      name = row[:location].upcase
      subject = row[:score].upcase
      year = row[:timeframe].to_i
      percent = row[:data].to_f
      grade = test_results.values[index]
      statewide_tests_object = find_by_name(name)
      if statewide_tests_object == nil
      statewide_tests[name] = StatewideTest.new({:name => name, grade=> {year => {subject => percent}}})
      else
        add_data_1(statewide_tests_object, grade, year, subject, percent)
      end
    end
  end

  def add_data_1(statewide_test_object, grade, year, subject, percent)
    if grade == :third_grade
      if statewide_test_object.third_grade.keys.include?(year)
        statewide_test_object.third_grade[year][subject] = percent
      else
        statewide_test_object.third_grade[year] = { subject => percent }
      end
    elsif grade == :eighth_grade
      if statewide_test_object.eighth_grade.keys.include?(year)
        statewide_test_object.eighth_grade[year][subject] = percent
      else
        statewide_test_object.eighth_grade[year] = { subject => percent }
      end
    end
  end

  def read_file_2(data, filepath, index)
    CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
      name = row[:location].upcase
      ethnicity = test_results[row[:race_ethnicity].upcase]
      year = row[:timeframe].to_i
      percent = row[:data].to_f
      subject = data.values[0].keys[index].to_s
      statewide_tests_object = find_by_name(name)
      if statewide_tests_object == nil
      statewide_tests[name] = StatewideTest.new({:name => name, ethnicity => {year => {subject => percent}}})
      else
        add_data_2(statewide_tests_object, year, ethnicity, subject, percent)
      end
    end
  end

  def add_data_2(statewide_test_object, year, ethnicity, subject, percent)
    if statewide_test_object.attributes[ethnicity].nil?
      statewide_test_object.attributes[ethnicity] = { year => { subject => percent }}
    elsif
      statewide_test_object.attributes[ethnicity][year].nil?
      statewide_test_object.attributes[ethnicity][year] = {subject => percent}
    else
      statewide_test_object.attributes[ethnicity][year][subject] = percent
    end
  end

  def find_by_name(district_name)
    statewide_tests[district_name]
  end

  def check_loadpath(data, filepath, index)
    if filepath.include?("grade")
      read_file_1(data, filepath, index)
    else
      read_file_2(data, filepath, index)
    end
  end

end

str = StatewideTestRepository.new
str.load_data({
  :statewide_testing => {
    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
    :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
    :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
    :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
  }
})

binding.pry
str.statewide_tests
