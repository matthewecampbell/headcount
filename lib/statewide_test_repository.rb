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
      subject = row[:score].downcase.to_sym
      year = row[:timeframe].to_i
      percent = truncate_float(row[:data].to_f)
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
    if statewide_test_object.attributes[grade].nil?
      statewide_test_object.attributes[grade] = {year => {subject => percent}}
    elsif statewide_test_object.attributes[grade][year].nil?
      statewide_test_object.attributes[grade][year] = { subject => percent }
    else
      statewide_test_object.attributes[grade][year][subject] = percent
    end
  end


  def read_file_2(data, filepath, index)
    CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
      name = row[:location].upcase
      ethnicity = test_results[row[:race_ethnicity].upcase].to_sym
      year = row[:timeframe].to_i
      percent = truncate_float(row[:data].to_f)
      subject = data.values[0].keys[index].to_sym
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

  def truncate_float(float)
    float = 0 if float.nan?
    (float * 1000).floor / 1000.to_f
  end
end
