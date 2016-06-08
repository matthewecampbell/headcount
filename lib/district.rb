require_relative 'enrollment'

class District
  attr_reader :attributes, :enrollment_data

  def initialize(attributes, enrollment_data = nil)
    @attributes = attributes
    @enrollment_data = enrollment_data
  end

  def name
    attributes[:name].upcase
  end

  def enrollment
    enrollment_data
  end

end
