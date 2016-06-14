
class Enrollment
  attr_reader :attributes, :name

  def initialize(attributes)
    @attributes = attributes
    @name = attributes[:name]
  end

  def kindergarten_participation_by_year
    attributes[:kindergarten_participation].reduce({}) do |result, pair|
      result.merge({pair.first => truncate_float(pair.last.to_f)})
    end
  end

  def truncate_float(float)
    float = 0 if float.nan?
    (float * 1000).floor / 1000.to_f
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation_by_year[year]
  end

  def graduation_rate_by_year
    attributes[:high_school_graduation].reduce({}) do |result, pair|
      result.merge({pair.first => truncate_float(pair.last)})
    end
  end

  def graduation_rate_in_year(year)
    graduation_rate_by_year[year]
  end

  def kindergarten_participation
    attributes[:kindergarten_participation]
  end

  def high_school_graduation
    if high_school_graduation_data_exists?
      return attributes[:high_school_graduation]
    end
    attributes[:high_school_graduation] = Hash.new
  end

  def high_school_graduation_data_exists?
    attributes.has_key?(:high_school_graduation)
  end

end
