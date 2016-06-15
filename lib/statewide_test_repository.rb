require 'csv'
require_relative 'statewide_test'
require_relative 'calc'
require_relative 'data_parser'

class StatewideTestRepository
    include Calc
    include DataParser
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
    load_file_data(data)
  end

  def read_grade_file(data, filepath, index)
    CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
      name               = find_name(row).upcase
      grade              = find_grade(index)
      sub_grade          = find_sub_grade(row)
      year               = find_year(row)
      percent            = find_percent(row)
      object             = find_by_name(name)

      create_statewide_object(name, grade, year, sub_grade, percent, object)
    end
  end

  def read_race_file(data, filepath, index)
    CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
      name            = find_name(row).upcase
      ethnicity       = find_ethnicity(row)
      year            = find_year(row)
      percent         = find_percent(row)
      sub_race        = find_sub_race(data, index)
      object          = find_by_name(name)

      create_statewide_object(name, ethnicity, year, sub_race, percent, object)
    end
  end

  def add_data(object, category, year, subject, data)
    if object_category_exists?(object, category)
      add_year_subject_data(object, category, year, subject, data)
    elsif object_year_exists?(object, category, year)
      add_subject_and_data(object, category, year, subject, data)
    else
      add_number_or_percent(object, category, year, subject, data)
    end
  end

  def find_by_name(district_name)
    statewide_tests[district_name]
  end


end
