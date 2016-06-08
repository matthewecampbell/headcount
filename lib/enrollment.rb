require 'pry'

class Enrollment
  attr_reader :attributes, :name

  def initialize(attributes)
    @attributes = attributes
    @name = attributes[:name]
  end

  def kindergarten_participation_by_year
    attributes[:kindergarten_participation].reduce({}) do |result, pair|
      result.merge({pair.first => truncate_float(pair.last)})
    end
  end

  def truncate_float(float)
    (float * 1000).floor / 1000.to_f
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation_by_year[year]
  end

end
