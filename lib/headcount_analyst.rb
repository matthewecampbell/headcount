require_relative 'calc'

class HeadcountAnalyst
    include Calc
  attr_reader     :dr

  def initialize(dr)
    @dr = dr
  end

  def kindergarten_participation_rate_variation(dist, divisor)
    dist_part = part_rate(district_years(dist, :kindergarten_participation))
    div_part = part_rate(divisor_years(divisor, :kindergarten_participation))
    truncate_float(dist_part/div_part)
  end

  def district_years(dist, grade_level)
    dr.find_enrollment(dist).attributes[grade_level]
  end

  def divisor_years(divisor, grade_level)
    dr.find_enrollment(divisor[:against]).attributes[grade_level]
  end

  def part_rate(data)
    number_of_years = data.count
    rate = data.values.reduce(:+)
    rate/number_of_years
  end

  def kindergarten_participation_rate_variation_trend(dist, divisor)
    dsyears = district_years(dist, :kindergarten_participation)
    dvyears = divisor_years(divisor, :kindergarten_participation)
    dsyears.merge(dvyears) {|key, val, newval| truncate_float(val/newval) }
  end

  def kindergarten_participation_against_high_school_graduation(dist)
    k = kindergarten_participation_rate_variation(dist, {:against=>"COLORADO"})
    h = high_school_graduation_rate_variation(dist, {:against=>"COLORADO"})
    truncate_float(k/h)
  end

  def high_school_graduation_rate_variation(dist, divisor)
    dist_part = part_rate(district_years(dist, :high_school_graduation))
    div_part = part_rate(divisor_years(divisor, :high_school_graduation))
    truncate_float(dist_part/div_part)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(dist)
    district_name = dist.class == String ?  dist : dist.values[0]
    parse_correlation_distric(district_name)
  end

  def parse_correlation_distric(district_name)
    case
    when district_name.class == Array
      statewide_comparison(district_name)
    when district_name != "STATEWIDE"
      correlation(district_name)
    when district_name == "STATEWIDE"
      statewide_comparison
    else
      correlation(district_name)
    end
  end

  def correlation(dist)
    data = kindergarten_participation_against_high_school_graduation(dist)
    correlated?(data)
  end

  def correlated?(correlation)
    correlation > 0.6 && correlation < 1.5 ? true : false
  end

  def statewide_comparison(sub_districts = nil)
    district_names = sub_districts
    district_names = dr.get_all_district_names if sub_districts.nil?
    compare_statewide_data(district_names)
  end

  def compare_statewide_data(district_names)
    # enums
    results = []
    district_names.map do |district_name|
      if district_name != "COLORADO"
        results << kindergarten_participation_correlates_with_high_school_graduation(district_name)
      end
    end
    calculate_statewide_data(results)
  end

  def calculate_statewide_data(results)
    # use an appropriate enumberable here
    total = results.count
    counter = 0
    results.each { |result| counter += 1 if result == true }
    percentage = truncate_float(counter/ total.to_f)
    thing = percentage >= 0.7 ? true : false
  end

  def high_poverty_and_high_school_graduation
    matching_districts = []
    dr.districts.keys.each do |district_name|
      if district_name != "COLORADO"
      district = dr.find_by_name(district_name)
      check_1 = students_qualifying_for_lunch?(district)
      check_2 = children_in_poverty?(district)
      check_3 = graduation_rate?(district)
      if check_1 && check_2 && check_3
        matching_districts << ResultEntry.new({name: district_name, free_or_reduced_price_lunch:
          @dist_average, children_in_poverty_rate: @poverty_average,
          high_school_graduation_rate: @grad_average})
        end
      end
    end
    statewide_result = ResultEntry.new({name: "COLORADO", free_or_reduced_price_lunch:
      @s_lunch, children_in_poverty_rate: @s_poverty,
      high_school_graduation_rate: @s_grad})
    high_poverty_and_grad_result = ResultSet.new(matching_districts: matching_districts,statewide_average: statewide_result)
  end

  def high_income_disparity
    matching_districts = []
    dr.districts.keys.each do |district_name|
      if district_name != "COLORADO"
        district = dr.find_by_name(district_name)
        check_1 = median_household_income?(district)
        check_2 = children_in_poverty?(district)
        if check_1 && check_2
          matching_districts << ResultEntry.new({name: district_name, median_household_income:
          @income_average, children_in_poverty_rate: @poverty_average,
          })
        end
      end
    end
    statewide_result = ResultEntry.new({name: "COLORADO", median_household_income:
      @s_income, children_in_poverty_rate: @s_poverty})
    high_poverty_and_grad_result = ResultSet.new(matching_districts: matching_districts,statewide_average: statewide_result)
  end

  def kindergarten_participation_against_household_income(district_name)
      if district_name != "COLORADO"
      district = dr.find_by_name(district_name)
      state = dr.find_by_name("COLORADO")
      median_household_income?(district)
      @income_average/@s_income.to_f
    end
  end

  def kindergarten_participation_correlates_with_household_income(district_name)
    # use an appropriate enumberable here
    results = []
    if district_name[:for] == "STATEWIDE"
    dr.districts.keys.each do |district_name|
      if district_name != "COLORADO"
      district = dr.find_by_name(district_name)
      median_household_income?(district)
      results << if 0.6 < @income_average/@s_income && @income_average/@s_income < 1.5
      end
    end
  end
  counter = 0
    results.each do |result|
      counter += 1 if result == true
    end
    counter/results.count > 0.70
  else
    district = dr.find_by_name(district_name[:for])
    median_household_income?(district)
    0.6 < @income_average/@s_income && @income_average/@s_income < 1.5
  end
  end

  def median_household_income?(district)
    # use an appropriate enumberable here

    # free_and_reduced_price_lunch
    nums = []
    percentage = district.economic_profile.attributes[:median_household_income].values
    percentage.each do |value|
      nums << value if value.is_a?(Fixnum)
      end
    total = nums.reduce(:+)
    @income_average = total/nums.count
    @income_average > statewide_average_income
  end

  def statewide_average_income
    state = dr.find_economic_profile("COLORADO").attributes
    total = state[:median_household_income].values.reduce(:+)
    @s_income = total/state[:median_household_income].values.count
  end

  def students_qualifying_for_lunch?(district)
    # free_and_reduced_price_lunch
    percentages = []
    percentage = district.economic_profile.attributes[:free_and_reduced_price_lunch_rate].values.map do |hash|
      if hash[:percentage].is_a?(Float)
      percentages << hash[:percentage]
      end
    end
    @dist_average = percentages.reduce(:+)/percentages.count
    @dist_average > statewide_average_lunch
  end

  def statewide_average_lunch
    percentages = []
    dr.districts.keys.each do |district_name|
      district = dr.find_by_name(district_name)
      district.economic_profile.attributes[:free_and_reduced_price_lunch_rate].values.map do |hash|
        if hash[:percentage].is_a?(Float)
          percentages  << hash[:percentage]
        end
      end
    end
    @s_lunch = truncate_float(percentages.compact.reduce(:+)/percentages.count)
  end

  def children_in_poverty?(district)
    percentages = []
    percentage = district.economic_profile.attributes[:children_in_poverty].values.map do |hash|
      if hash[:percentage].is_a?(Float)
      percentages << hash[:percentage]
    end
    end
    @poverty_average = percentages.reduce(:+)/percentages.count
    @poverty_average > statewide_poverty
  end

  def statewide_poverty
    percentages = []
    dr.districts.keys.each do |district_name|
      if district_name != "COLORADO"
      district = dr.find_by_name(district_name)
      district.economic_profile.attributes[:children_in_poverty].values.map do |hash|
        if hash[:percentage].is_a?(Float)
          percentages  << hash[:percentage]
        end
        end
      end
    end
    @s_poverty = truncate_float(percentages.compact.reduce(:+)/percentages.count)
  end

  def graduation_rate?(district)
    percentage = district.enrollment.attributes[:high_school_graduation].values
    @grad_average = percentage.reduce(:+)/percentage.count
    @grad_average > statewide_graduation
  end

  def statewide_graduation
    state = dr.enrollment_repository.enrollments["COLORADO"].attributes
    total = state[:high_school_graduation].values.reduce(:+)
    @s_grad = truncate_float(total/state[:high_school_graduation].values.count)
  end

end
