require 'csv'

class DistrictRepo
  attr_reader :districts

  def initialize(districts = [])
    @districts = districts
  end

  def load_data(data)

  end

  def find_by_name(district_name)
    districts.detect do |district|
      district.attributes[:name] == district_name
    end
  end

end
