require 'pry'
require 'csv'
require_relative 'enrollment'

class EnrollmentRepository
  attr_reader :enrollments

  def initialize(enrollments = [])
    @enrollments = enrollments
  end

  def load_data(data)
    file = data.dig(:enrollment, :kindergarten)
    sort_years(file)
  end

  def sort_years(file)
    years = CSV.foreach(file, headers: true, header_converters: :symbol).map do |row|
      { :name => row[:location], row[:timeframe].to_i => row[:data].to_f }
    end
    group_by_district(years)
  end

  def group_by_district(years)
    group_names = years.group_by do |row|
      row[:name]
    end
    move_to_collections(group_names)
  end

  def move_to_collections(group_names)
    collection = group_names.map do |name, years|
      merged = years.reduce({}, :merge)
      merged.delete(:name)
      { name: name,
        kindergarten_participation: merged }
      end
      create_enrollments(collection)
  end

  def create_enrollments(collection)
      collection.each do |line|
        enrollments << Enrollment.new(line)
      end
  end

  def find_by_name(district_name)
    enrollments.detect do |enrollment|
      enrollment.attributes[:name] == district_name
    end
  end

end
