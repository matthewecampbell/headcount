require 'pry'
class HeadcountAnalyst
  attr_reader     :dr

  def initialize(dr)
    @dr = dr
  end

  def kindergarten_participation_rate_variation(district, divisor)
    district_participation = participation_rate(k_district_years(district))
    divisor_participation = participation_rate(k_divisor_years(divisor))
    truncate_float(district_participation/divisor_participation)
  end

  def k_district_years(district)
    dr.find_enrollment(district).attributes[:kindergarten_participation]
  end

  def k_divisor_years(divisor)
    dr.find_enrollment(divisor[:against]).attributes[:kindergarten_participation]
  end

  def participation_rate(data)
    number_of_years = data.count
    rate = data.values.reduce(:+)
    rate/number_of_years
  end

  def kindergarten_participation_rate_variation_trend(district, divisor)
    k_district_years(district).merge(k_divisor_years(divisor)) do |key, orval, newval|
       truncate_float(orval/newval)
    end
  end

  # def kindergarten_participation_against_high_school_graduation(district)
  #   kindergarten_variation = kindergarten_participation_rate_variation(district, {:against=>"COLORADO"})
  #
  #   #Call graduation variation the result of dividing the district's graduation rate by the statewide average. Divide the kindergarten variation by the graduation variation to find the kindergarten-graduation variance.
  # end

  def truncate_float(float)
    (float * 1000).floor / 1000.to_f
  end

end
