require_relative 'errors'

class StatewideTest
  attr_reader :attributes, :name, :grade_levels

  def initialize(attributes)
    @attributes = attributes
    @name = attributes[:name]
    @grade_levels =   {
      3 => :third_grade,
      8 => :eighth_grade
    }
  end

  def proficient_by_grade(grade)
    raise UnknownDataError if grade_levels[grade].nil?
    attributes[grade_levels[grade]]
  end

  def proficient_by_race_or_ethnicity(race)
    raise UnknownRaceError if attributes[race].nil?
    attributes[race]
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    raise UnknownDataError if attributes[grade_levels[grade]][year][subject].nil?
    attributes[grade_levels[grade]][year][subject]
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    raise UnknownDataError if attributes[race].nil?
    raise UnknownDataError if attributes[race][year][subject].nil?
    attributes[race][year][subject]
  end

end
