class ResultEntry
attr_reader :attributes

  def initialize(attributes)
    @attributes = attributes
  end

  def free_or_reduced_price_lunch
    attributes[:free_or_reduced_price_lunch]
  end

  def children_in_poverty_rate
    attributes[:children_in_poverty_rate]
  end

  def high_school_graduation_rate
    attributes[:high_school_graduation_rate]
  end

  def name
    attributes[:name]
  end

  def median_household_income
    attributes[:median_household_income]
  end
end
