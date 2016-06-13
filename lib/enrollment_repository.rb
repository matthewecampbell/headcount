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
    #refactor?
      CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
        name = row[:location].upcase
        year = row[:timeframe].to_i
        percent = row[:data].to_f
        #changed commented code to .values[index]
        grade = grade_levels.values[index] #[data.values[0].keys[index]]
        enrollments_object = find_by_name(name)
        enrollment_attributes = {:name => name, grade => {year => percent}}
        if enrollments_object == nil
          enrollments[name] = Enrollment.new(enrollment_attributes)
        else
          add_data(enrollments_object, grade, year, percent)
      end
    end
  end

  def add_data(enrollment_object, grade, year, percent)
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
