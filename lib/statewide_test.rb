require_relative 'errors'
require_relative 'finder'

class StatewideTest
  include Finder
  attr_reader :attributes, :name, :grade_levels, :error

  def initialize(attributes)
    @attributes = attributes
    @name = attributes[:name]
    @grade_levels =   {
      3 => :third_grade,
      8 => :eighth_grade
    }
    @error = UnknownDataError
  end

  def proficient_by_grade(grade)
    raise error unless grade_level_exists(grade)
    find_proficient_by_grade(grade)
  end

  def proficient_by_race_or_ethnicity(race)
    raise UnknownRaceError unless race_exists(race)
    find_proficient_by_race_or_ethinicity(race)
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    raise error unless year_exists(subject, grade, year)
    raise error unless subject_exists_in_year_and_grade(subject, grade, year)
    find_proficient_by_subject_by_grade_in_year(subject, grade, year)
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    raise error unless race_exists(race)
    raise error unless subject_exists_in_year_and_race(subject, race, year)
    find_proficient_by_subject_by_race_in_year(subject, race, year)
  end
end
