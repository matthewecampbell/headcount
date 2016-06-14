class HeadcountAnalyst
  attr_reader     :dr

  def initialize(dr)
    @dr = dr
  end

  def kindergarten_participation_rate_variation(district, divisor)
    # compares kindergarten participation in one district to another (OR VS STATE)
    district_participation = participation_rate(district_years(district, :kindergarten_participation))
    divisor_participation = participation_rate(divisor_years(divisor, :kindergarten_participation))
    truncate_float(district_participation/divisor_participation)
  end

  def district_years(district, grade_level)
    # returns a hash of years pointing to participation percentage for the primary DISTRICT
    dr.find_enrollment(district).attributes[grade_level]
  end

  def divisor_years(divisor, grade_level)
    # returns a hash of years pointing to participation percentage for the "other" district (OR STATE)
    dr.find_enrollment(divisor[:against]).attributes[grade_level]
  end

  def participation_rate(data)
    # if you don't know what this method does it's time to go home
    number_of_years = data.count
    rate = data.values.reduce(:+)
    rate/number_of_years
  end

  def kindergarten_participation_rate_variation_trend(district, divisor)
    # returns a hash of the merged values of the district and divisor(district or STATE) percentages by year
    dsyears = district_years(district, :kindergarten_participation)
    dvyears = divisor_years(divisor, :kindergarten_participation)
    dsyears.merge(dvyears) { |key, orval, newval| truncate_float(orval/newval) }
  end

  def kindergarten_participation_against_high_school_graduation(district)
    # returns the percentage of kinder participation divided by graduation by district (against STATE (hardcoded))
    kindergarten_variation = kindergarten_participation_rate_variation(district, {:against=>"COLORADO"})
    graduation_variation = high_school_graduation_rate_variation(district, {:against=>"COLORADO"})
    truncate_float(kindergarten_variation/graduation_variation)
  end

  def high_school_graduation_rate_variation(district, divisor)
    # returns the percentage of graduation rates divided by that of another district (or STATE)
    district_participation = participation_rate(district_years(district, :high_school_graduation))
    divisor_participation = participation_rate(divisor_years(divisor, :high_school_graduation))
    truncate_float(district_participation/divisor_participation)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(district)
    #refactor
    if district.class == String
      district = district
    elsif district.include?(:for)
      district = district[:for]
    elsif district.include?(:across)
      district = district[:across]
    else
      district = district
    end

    if district.class == Array
      return statewide_comparison(district)
    elsif district != "STATEWIDE"
      return correlation(district)
    elsif district == "STATEWIDE"
      return statewide_comparison
    else
      correlation(district)
    end
  end

  def correlation(district)
    correlation = kindergarten_participation_against_high_school_graduation(district)
    correlated?(correlation)
  end

  def correlated?(correlation)
    correlation > 0.6 && correlation < 1.5 ? true : false
  end

  def statewide_comparison(sub_districts = nil)
    #refactor
    district_names = dr.get_all_district_names
    sub_districts
    results = []
    if sub_districts.nil?
      names = district_names
    else
      names = sub_districts
    end
    names.map do |district_name|
      if district_name != "COLORADO"
        results << kindergarten_participation_correlates_with_high_school_graduation(district_name)
      end
    end
    total = results.count
    counter = 0
    results.each { |result| counter += 1 if result == true }
    percentage = truncate_float(counter/ total.to_f)
    thing = percentage >= 0.7 ? true : false
  end


  def truncate_float(float)
    float = 0 if float.nan?
    (float * 1000).floor / 1000.to_f
  end

end
