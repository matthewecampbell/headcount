require 'pry'
class HeadcountAnalyst
  attr_reader     :district_repository

  def initialize(dr)
    @district_repository = dr
  end

  def kindergarten_participation_rate_variation(district_1, district_2)
    district_one = @district_repository.find_by_name(district_1)
    num_years_1 = district_one.attributes[:kindergarten_participation].length
    total_participation_rate_1 = district_one.attributes[:kindergarten_participation].values.reduce(:+)
    participation_rate_1 = total_participation_rate_1/num_years_1
    district_two = @district_repository.find_by_name(district_2[:against])
    num_years_2 = district_two.attributes[:kindergarten_participation].length
    total_participation_rate_2 = district_two.attributes[:kindergarten_participation].values.reduce(:+)
    participation_rate_2 = total_participation_rate_2/num_years_2
    result = participation_rate_1 / participation_rate_2
    truncate_float(result)
  end

  def kindergarten_participation_rate_variation_trend(district_1, district_2)
    district_one = @district_repository.find_by_name(district_1)
    district_two = @district_repository.find_by_name(district_2[:against])
    by_year_1 = district_one.enrollment.attributes[:kindergarten_participation]
    by_year_2 = district_two.enrollment.attributes[:kindergarten_participation]
    sorted_1 = by_year_1.sort.map { |pair| pair }
    sorted_2 = by_year_2.sort.map { |pair| pair }
    zipped = sorted_1.zip(sorted_2)
    flattened = zipped.map { |each| each.flatten.uniq }
    compared = {}
    flattened.each do |year|
      compared[year[0]] = truncate_float(year[1]/year[2])
    end
    compared
  end

  def truncate_float(float)
    (float * 1000).floor / 1000.to_f
  end

end
