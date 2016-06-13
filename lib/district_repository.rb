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

  def load_data(data)
    enrollment_data = {}
    enrollment_data[data.first[0]] = data.first[1]
    enrollment_repository.load_data(enrollment_data)
    if data.count > 1
      statewide_testing_data = {}
      statewide_testing_data[:statewide_testing] = data[:statewide_testing]
      statewide_test_repository.load_data(statewide_testing_data)
    end
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
