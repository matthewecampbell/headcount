require 'csv'

class DistrictRepo
  attr_reader :districts

  def initialize(districts = [])
    @districts = districts
  end

  def load_data(data)
    file = data.dig(:enrollment, :kindergarten)
    years = CSV.foreach(file, headers: true, header_converters: :symbol).map do |row|
      { :name => row[:location], row[:timeframe].to_i => row[:data].to_f }
    end
    group_names = years.group_by do |row|
      row[:name]
    end
    collection = group_names.map do |name, years|
      merged = years.reduce({}, :merge)
      merged.delete(:name)
      { name: name,
        kindergarten_participation: merged }
      end
      collection.each do |line|
        districts << District.new(line)
      end
  end

  def find_by_name(district_name)
    districts.detect do |district|
      district.attributes[:name] == district_name
    end
  end

  def find_all_matching(fragment)
    districts.select do |district|
      district.attributes[:name].start_with?(fragment)
    end
  end

end
