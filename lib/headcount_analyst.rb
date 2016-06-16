require_relative 'calc'

class HeadcountAnalyst
  include Calc
  attr_reader    :dr

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
    r = []
    district_names.map do |district_name|
      statewide_data_comparison(district_name, r)
    end
    calculate_statewide_data(r)
  end

  def statewide_data_comparison(dn, r)
    if dn != "COLORADO"
      r << kindergarten_participation_correlates_with_high_school_graduation(dn)
    end
  end

  def calculate_statewide_data(results)
    total = results.count
    counter = results.count { |result| result == true }
    percentage = truncate_float(counter/ total.to_f)
    percentage >= 0.7 ? true : false
  end

  def high_poverty_and_high_school_graduation
    md = []
    dr.districts.keys.each do |district_name|
      if high_poverty_and_grad_check(district_name)
        md << ResultEntry.new({name: district_name, free_or_reduced_price_lunch:
          @dist_average, children_in_poverty_rate: @poverty_average,
          high_school_graduation_rate: @grad_average})
        end
    end
    high_poverty_and_grad_result(md)
  end

  def high_poverty_and_grad_result(md)
    sr = ResultEntry.new({name: "COLORADO", free_or_reduced_price_lunch:
    @s_lunch, children_in_poverty_rate: @s_poverty,
    high_school_graduation_rate: @s_grad})
    ResultSet.new(matching_districts: md, statewide_average: sr)
  end

  def high_poverty_and_grad_check(district_name)
    if district_name != "COLORADO"
      district = dr.find_by_name(district_name)
      check_1 = students_qualifying_for_lunch?(district)
      check_2 = children_in_poverty?(district)
      check_3 = graduation_rate?(district)
      check_1 && check_2 && check_3
    end
  end

  def high_income_disparity
    md = []
    dr.districts.keys.each do |district_name|
      if high_income_disparity_check(district_name)
          md << ResultEntry.new({name: district_name, median_household_income:
          @income_average, children_in_poverty_rate: @poverty_average,
          })
        end
    end
    high_income_disparity_result(md)
  end

  def high_income_disparity_result(md)
    sr = ResultEntry.new({name: "COLORADO", median_household_income:
    @s_income, children_in_poverty_rate: @s_poverty})
    ResultSet.new(matching_districts: md, statewide_average: sr)
  end

  def high_income_disparity_check(district_name)
    if district_name != "COLORADO"
      district = dr.find_by_name(district_name)
      check_1 = median_household_income?(district)
      check_2 = children_in_poverty?(district)
      check_1 && check_2
    end
  end

  def kindergarten_participation_against_household_income(district_name)
    if district_name != "COLORADO"
      district = dr.find_by_name(district_name)
      state = dr.find_by_name("COLORADO")
      median_household_income?(district)
      truncate_float(@income_average/@s_income.to_f)
    end
  end

  def kindergarten_participation_correlates_with_household_income(district_name)
    results = []
    if district_name[:for] == "STATEWIDE"
      dr.districts.keys.each do |district_name|
        make_results(district_name, results)
    end
      tally_results(results)
    else
      district = dr.find_by_name(district_name[:for])
      median_household_income?(district)
      0.6 < @income_average/@s_income && @income_average/@s_income < 1.5
    end
  end

  def make_results(district_name, results)
    kindergarten_correlates_with_household_income_check(district_name)
    if 0.6 < @income_average/@s_income && @income_average/@s_income < 1.5
      results << true
    else
      results << false
    end
    results
  end

  def tally_results(results)
    counter = results.count {|result| result == true}
    counter/results.count > 0.70
  end

  def kindergarten_correlates_with_household_income_check(district_name)
    if district_name != "COLORADO"
    district = dr.find_by_name(district_name)
    median_household_income?(district)
    end
  end

  def median_household_income?(district)
    nums = []
    pc = district.economic_profile.attributes[:median_household_income].values
    pc.each do |value|
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
    percentages = []
    fl = district.economic_profile.attributes[:free_or_reduced_price_lunch]
    percentage = fl.values.each do |free_lunch_data|
      if free_lunch_data[:percentage].is_a?(Float)
      percentages << free_lunch_data[:percentage]
      end
    end
    @dist_average = percentages.reduce(:+)/percentages.count
    @dist_average > statewide_average_lunch
  end

  def statewide_average_lunch
    percentages = []
    dr.districts.keys.each do |district_name|
      statewide_lunch_percentages(district_name, percentages)
    end
    @s_lunch = truncate_float(percentages.compact.reduce(:+)/percentages.count)
  end

  def statewide_lunch_percentages(district_name, percentages)
    district = dr.find_by_name(district_name)
    fl = district.economic_profile.attributes[:free_or_reduced_price_lunch]
    fl.values.map do |hash|
      if hash[:percentage].is_a?(Float)
        percentages  << hash[:percentage]
      end
    end
  end

  def children_in_poverty?(district)
    percentages = []
    poverty = district.economic_profile.attributes[:children_in_poverty]
    percentage = poverty.values.each do |hash|
      if hash[:percentage].is_a?(Float)
      percentages << hash[:percentage]
    end
    end
    @poverty_average = percentages.reduce(:+)/percentages.count
    @poverty_average > statewide_poverty
  end

  def statewide_poverty
    pc = []
    dr.districts.keys.each do |district_name|
      statewide_poverty_percentages(district_name, pc)
    end
    @s_poverty = truncate_float(pc.compact.reduce(:+)/pc.count)
  end

  def statewide_poverty_percentages(district_name, percentages)
    if district_name != "COLORADO"
      district = dr.find_by_name(district_name)
      poverty_data = district.economic_profile.attributes[:children_in_poverty]
      poverty_data.values.each do |poverty|
      get_statewide_poverty_percentages(poverty, percentages)
      end
    end
  end

  def get_statewide_poverty_percentages(poverty, percentages)
    if poverty[:percentage].is_a?(Float)
      percentages  << poverty[:percentage]
    end
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
