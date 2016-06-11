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

  # def find_file(data)
  #   file = data.keys.map do |key|
  #     if key == :enrollment
  #       data[:enrollment].keys.map do |next_key|
  #         if next_key == :kindergarten
  #            data[:enrollment][:kindergarten]
  #         elsif
  #           next_key == :high_school_graduation
  #            data[:enrollment][:high_school_graduation]
  #         end
  #       end
  #     end
  #   end
  #   file.flatten
  # end
  #
  # def load_data(data)
  #   file = find_file(data)
  #   file.map { |file_path| sort_years(file_path) }
  # end
  #
  # def sort_years(file)
  #   years = CSV.foreach(file, headers: true, header_converters: :symbol).map do |row|
  #     { :name => row[:location], row[:timeframe].to_i => row[:data].to_f }
  #   end
  #   group_by_district(years)
  # end
  #
  # def group_by_district(years)
  #   group_names = years.group_by do |row|
  #     row[:name]
  #   end
  #   move_to_collections(group_names)
  # end
  #
  # def move_to_collections(group_names)
  #   collection = group_names.map do |name, years|
  #     merged = years.reduce({}, :merge)
  #     merged.delete(:name)
  #     { name: name.upcase,
  #       kindergarten_participation: merged }
  #     end
  #     create_enrollments(collection)
  # end
  #
  # def create_enrollments(collection)
  #     collection.each do |line|
  #       enrollments[line[:name]] = Enrollment.new(line)
  #     end
  # end

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
