require 'csv'

class DistrictRepo
  attr_reader :districts

  def initialize
    @districts = []
  end

  def load_data(data)
    file = data.dig(:enrollment, :kindergarten)
    contents = CSV.open file, headers: true, header_converters: :symbol
      contents.each do |row|
      districts << row[:location]
    end
  end

  def find_by_name(district)
    districts.detect { |district| district }
    #go into the hash containing the file
    #search the file for the district
    #return the distric object
    binding.pry
  end

end
