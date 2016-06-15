require 'csv'
require_relative 'enrollment_repository'
require_relative 'district'
require_relative 'statewide_test_repository'
require_relative 'economic_profile_repository'

class DistrictRepository
  attr_reader :districts,
              :enrollment_repository,
              :statewide_test_repository,
              :parser,
              :economic_profile_repository

  def initialize(districts = {})
    @districts = districts
    @enrollment_repository = EnrollmentRepository.new
    @statewide_test_repository = StatewideTestRepository.new
    @economic_profile_repository = EconomicProfileRepository.new
  end

  def load_data(data)
    sort_enrollment(data)
    sort_statewide_testing(data)
    sort_economic_profile(data)
    create_districts
  end

  def sort_enrollment(data)
    if data.keys.include?(:enrollment)
      enrollment_data = {}
      enrollment_data[data.first[0]] = data.first[1]
      enrollment_repository.load_data(enrollment_data)
    end
  end

  def sort_statewide_testing(data)
    if data.keys.include?(:statewide_testing)
      statewide_testing_data = {}
      statewide_testing_data[:statewide_testing] = data[:statewide_testing]
      statewide_test_repository.load_data(statewide_testing_data)
    end
  end

  def sort_economic_profile(data)
    if data.keys.include?(:economic_profile)
      economic_profile_data = {}
      economic_profile_data[:economic_profile] = data[:economic_profile]
      economic_profile_repository.load_data(economic_profile_data)
    end
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

  def get_all_district_names
    enrollment_repository.enrollments.keys
  end

  def find_enrollment(name)
    enrollment_repository.enrollments[name]
  end

  def repositories
    {:enrollment => enrollment_repository}
  end

  def find_statewide_test(name)
    statewide_test_repository.statewide_tests[name]
  end

  def find_economic_profile(name)
    economic_profile_repository.economic_profiles[name]
  end

end
