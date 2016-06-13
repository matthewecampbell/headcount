require 'csv'
require_relative 'enrollment_repository'
require_relative 'district'
require_relative 'statewide_test_repository'
require_relative 'parser'

class DistrictRepository
  attr_reader :districts, :enrollment_repository, :statewide_test_repository, :parser

  def initialize(districts = {})
    @districts = districts
    @enrollment_repository = EnrollmentRepository.new
    @statewide_test_repository = StatewideTestRepository.new
    @parser = Parser.new
    @data_collections
  end

  def find_file(data)
    file = data.keys.map do |key|
      if key == :enrollment
        data[:enrollment].keys.map do |next_key|
          if next_key == :kindergarten
             data[:enrollment][:kindergarten]
          elsif
            next_key == :high_school_graduation
             data[:enrollment][:high_school_graduation]
          end
        end
      else
        nil
      end
    end
    if file != nil
    file.flatten
    else
    file
    end
  end

  def load_data(data)
    enrollment_data = {}
    enrollment_data[data.first[0]] = data.first[1]
    enrollment_repository.load_data(enrollment_data)
    statewide_testing_data = {}
    statewide_testing_data[:statewide_testing] = data[:statewide_testing]
    statewide_test_repository.load_data(statewide_testing_data)
    create_districts
    # file = find_file(data)
    # if file != nil
    # file.map { |file_path| sort_years(file_path) }
  # end
  end

  def create_districts
    enrollment_repository.enrollments.keys.each do |name|
       districts[name] = District.new({:name => name}, self)
     end
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
      { name: name.upcase }
      end
      create_districts(collection)
  end

  # def create_districts(collection)
  #   collection.each do |line|
  #     districts[line[:name]] = District.new(line, self)
  #   end
  # end

  def find_by_name(district_name)
    districts[district_name]
  end

  def find_all_matching(fragment)
    names = districts.keys.select do |name|
      name.downcase.start_with?(fragment.downcase)
    end
    names.map do |name|
      districts[name]
    end
  end

  def find_enrollment(name)
    enrollment_repository.enrollments[name]
  end

  def repositories
    {:enrollment => enrollment_repository}
  end

  def get_all_district_names
    enrollment_repository.enrollments.keys
  end

  def find_statewide_test(name)
    statewide_test_repository.statewide_tests[name]
  end

end
