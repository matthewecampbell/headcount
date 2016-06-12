require 'pry'

class StatewideTest
  attr_reader :attributes, :name

  def initialize(attributes)
    @attributes = attributes
    @name = attributes[:name]
  end

  def third_grade
    attributes[:third_grade]
  end

  def eighth_grade
    return attributes[:eighth_grade] if eighth_grade_data_exists?
    attributes[:eighth_grade] = Hash.new
  end

  def eighth_grade_data_exists?
    attributes.has_key?(:eighth_grade)
  end

  def proficient_by_grade(grade)
    
  end

end
