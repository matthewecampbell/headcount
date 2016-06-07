require 'pry'
require 'csv'

class EnrollmentRepo
  attr_reader     :enrollments

  def initialize(enrollments = [])
    @enrollments = enrollments
  end

  def load_data(data)
    file = data.dig(:enrollment, :kindergarten)
    years = CSV.foreach(file, headers: true, header_converters: :symbol).map do |row|
      { :name => row[:location], row[:timeframe].to_i => row[:data].to_f }
    end
    group_names = years.group_by do |row|
      row[:name]
    end
    collection = group_names.map do |name, years|
      merged = years.reduce({}, :merge)
      merged.delete(:name)
      { name: name,
        kindergarten_participation: merged }
      end
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
