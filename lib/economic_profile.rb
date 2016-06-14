require_relative 'errors'

class EconomicProfile
  attr_reader :attributes

  def initialize(attributes)
    @attributes = attributes
  end

  def median_household_income_in_year(year)
    total = []
    attributes[:median_household_income].keys.map do |key|
      if year.between?(key[0], key[1])
        total << attributes[:median_household_income][key]
     end
    end
    total.reduce(:+) / total.count
  end

  def median_household_income_average
    total = attributes[:median_household_income].values.reduce(:+)
    total / attributes[:median_household_income].values.count
  end

  def children_in_poverty_in_year(year)
    children_in_poverty = attributes[:children_in_poverty]
    raise UnknownDataError if children_in_poverty[year].nil?
    children_in_poverty[year]
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    lunch_percentage = attributes[:free_or_reduced_price_lunch]
    raise UnknownDataError if lunch_percentage[year].nil?
    truncate_float(lunch_percentage[year][:percentage])
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    lunch_number = attributes[:free_or_reduced_price_lunch]
    raise UnknownDataError if lunch_number[year].nil?
    lunch_number[year][:total]
  end

  def title_i_in_year(year)
    title_i = attributes[:title_i]
    raise UnknownDataError if title_i[year].nil?
    title_i[year]
  end

  def truncate_float(float)
    float = 0 if float.nan?
    (float * 1000).floor / 1000.to_f
  end

end
