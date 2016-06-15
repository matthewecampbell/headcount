require 'csv'
require_relative 'economic_profile'
require_relative 'calc'
require_relative 'result_set'
require_relative 'data_parser'

class EconomicProfileRepository
    include Calc
    include DataParser
  attr_reader :data_types, :economic_profiles, :result_set

  def initialize(economic_profiles = {})
    @economic_profiles = economic_profiles
    @data_types =   {
      :median_household_income => :median_household_income,
      :children_in_poverty => :children_in_poverty,
      :free_or_reduced_price_lunch => :free_or_reduced_price_lunch,
      :title_i => :title_i
      }
  end

  def load_data(data)
    data.values[0].values.each_with_index do |filepath, index|
    read_file(data, filepath, index)
    end
  end

  def read_file(data, filepath, index)
    check_loadpath(data, filepath, index)
  end

  def check_loadpath(data, filepath, index)
    determine_read_path(data, filepath, index)
  end

  def read_income_file(data, filepath, index)
    CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
      name        = find_name(row).upcase
      year        = find_year_collection(row)
      income      = find_income(row)
      data_type   = find_data_types(data_types, index)
      object      = find_by_name(name)

      create_econ_or_title_income_object(object, name, data_type, year, income)
    end
  end

  def add_economic_or_title_data(object, data_type, year, data)
    add_income_or_title_data_to_object(object, data_type, year, data)
  end

  def read_poverty_and_lunch_file(data, filepath, index)
    CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
      name        = find_name(row).upcase
      year        = find_year(row)
      data_format = find_data_format(row)
      number      = find_number(row, data_format)
      data_type   = find_data_types(data_types, index)
      object      = find_by_name(name)

      create_poverty_object(object, name, year, data_format, number, data_type)
    end
  end

  def add_poverty_data(object, data_type, year, data_format, number)
    add_poverty_data_to_object(object, data_type, year, data_format, number)
  end

  def read_title_file(data, filepath, index)
    CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
      name        = find_name(row).upcase
      year        = find_year(row)
      percent     = find_percent(row)
      data_type   = find_data_types(data_types, index)
      object      = find_by_name(name)
      create_econ_or_title_income_object(object, name, data_type, year, percent)
    end
  end

  def find_by_name(district_name)
    economic_profiles[district_name]
  end
end
