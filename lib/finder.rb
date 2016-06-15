module Finder

  def grade_level_exists(grade)
    grade_levels[grade]
  end

  def find_proficient_by_grade(grade)
    attributes[grade_levels[grade]]
  end

  def race_exists(race)
    attributes[race]
  end

  def find_proficient_by_race_or_ethinicity(race)
    attributes[race]
  end

  def year_exists(subject, grade, year)
    attributes[grade_levels[grade]][year]
  end

  def subject_exists_in_year_and_grade(subject, grade, year)
    attributes[grade_levels[grade]][year][subject]
  end

  def find_proficient_by_subject_by_grade_in_year(subject, grade, year)
    attributes[grade_levels[grade]][year][subject]
  end

  def subject_exists_in_year_and_race(subject, race, year)
    attributes[race][year][subject]
  end

  def find_proficient_by_subject_by_race_in_year(subject, race, year)
    attributes[race][year][subject]
  end
end
