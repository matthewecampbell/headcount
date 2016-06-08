require 'csv'
require_relative 'enrollment_repository'

class DistrictRepository
  attr_reader :districts, :enrollment_repository

  def initialize(districts = [])
    @districts = districts
    @enrollment_repository = EnrollmentRepository.new
  end

  def load_data(data)
    enrollment_repository.load_data(data)
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
      create_districts(collection)
  end

  def create_districts(collection)
      collection.each do |line|
        enrollment_data = enrollment_repository.find_by_name(line[:name])
        districts << District.new(line, enrollment_data)
      end
  end

  def find_by_name(district_name)
    districts.detect do |district|
      district.attributes[:name] == district_name
    end
  end

  def find_all_matching(fragment)
    districts.select do |district|
      district.attributes[:name].start_with?(fragment)
    end
  end

end
