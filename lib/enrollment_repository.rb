require 'csv'
require_relative 'enrollment'
require_relative 'data_parser'
require_relative 'calc'

class EnrollmentRepository
  include DataParser
  include Calc
  attr_reader :enrollments, :grade_levels

  def initialize(enrollments = {})
    @enrollments = enrollments
    @grade_levels =   {
      :kindergarten => :kindergarten_participation,
      :high_school_graduation => :high_school_graduation
     }
  end

  def load_data(data)
    data.values[0].values.each_with_index do |filepath, index|
    read_file(data, filepath, index)
    end
  end

  def read_file(data, filepath, index)
    #refactor?
      CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
        name      = find_name(row).upcase
        year      = find_year(row)
        percent   = find_enrollment_percent(row)
        grade     = find_enrollment_grade(grade_levels, index)
        object    = find_by_name(name)

        create_enrollment_object(object, name, grade, year, percent)
    end
  end

  def add_data(object, grade, year, percent)
    add_enrollment_data(object, grade, year, percent)
  end

  def find_by_name(district_name)
    enrollments[district_name]
  end

end
