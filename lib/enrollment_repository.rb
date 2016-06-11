require 'pry'
require 'csv'
require_relative 'enrollment'

class EnrollmentRepository
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
      CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
        name = row[:location].upcase
        year = row[:timeframe].to_i
        percent = row[:data].to_f
        grade = grade_levels[data.values[0].keys[index]]
        check_enrollments = find_by_name(name)
        if check_enrollments == nil
          enrollments[name] = Enrollment.new({:name => name, grade => {year => percent}})
        else
          add_grade(check_enrollments, grade, year, percent)
      end
    end
  end

  def add_grade(enrollment_object, grade, year, percent)
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
