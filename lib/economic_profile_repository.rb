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
      :free_and_reduced_price_lunch_rate => :free_and_reduced_price_lunch_rate,
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

  def read_income_file(data, filepath, index)
    #refactor
    CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
      name = row[:location].upcase
      year = row[:timeframe].split("-").map { |num| num.to_i }
      income = "N/A"
      income = row[:data].to_i if row[:data] != "N/A"
      data_type = data_types.values[index]
      economic_profiles_object = find_by_name(name)
      if economic_profiles_object == nil
      economic_profiles[name] = EconomicProfile.new({:name => name, data_type => {year => income}})
      else
        add_economic_data(economic_profiles_object, data_type, year, income)
      end
    end
  end

  def add_economic_data(economic_profile_object, data_type, year, income)
    if economic_profile_object.attributes[data_type].nil?
      economic_profile_object.attributes[data_type] = {year => income}
    elsif economic_profile_object.attributes[data_type][year].nil?
      economic_profile_object.attributes[data_type][year] = income
    else
      economic_profile_object.attributes[data_type][year] = income
    end
  end

  def read_poverty_file(data, filepath, index)
    #refactor
    CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
      name = row[:location].upcase
      year = row[:timeframe].to_i
      data_format = row[:dataformat]
      if row[:dataformat] == "Percent"
        data_format = :percentage
      else
        data_format = :total
      end
      number = "N/A"
      if data_format == :percentage
      number = row[:data].to_f if row[:data] != "N/A"
      else
      number = row[:data].to_i if row[:data] != "N/A"
      end
      data_type = data_types.values[index]
      economic_profiles_object = find_by_name(name)
      if economic_profiles_object == nil
      economic_profiles[name] = EconomicProfile.new({:name => name, data_type  =>{year => {data_format => number}}})
      else
        add_poverty_data(economic_profiles_object, data_type, year, data_format, number)
      end
    end
  end

  def add_poverty_data(economic_profile_object, data_type, year, data_format, number)
    if economic_profile_object.attributes[data_type].nil?
      economic_profile_object.attributes[data_type] = {year => {data_format => number}}
    elsif economic_profile_object.attributes[data_type][year].nil?
      economic_profile_object.attributes[data_type][year] = {data_format => number}
    elsif economic_profile_object.attributes[data_type][year][data_format].nil?
      economic_profile_object.attributes[data_type][year][data_format] =  number
    else
      economic_profile_object.attributes[data_type][year][data_format] = number
    end
  end

  def read_lunch_file(data, filepath, index)
    #refactor
    CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
      name = row[:location].upcase
      year = row[:timeframe].to_i
      if row[:dataformat] == "Percent"
        data_format = :percentage
      else
        data_format = :total
      end
      number = "N/A"
      if data_format == :percentage
        number = row[:data].to_f if row[:data] != "N/A"
      else
        number = row[:data].to_i if row[:data] != "N/A"
      end
      data_type = data_types.values[index]
      economic_profiles_object = find_by_name(name)
      if economic_profiles_object == nil
        economic_profiles[name] = EconomicProfile.new({:name => name, data_type => {year => {data_format =>  number}}})
      else
        add_lunch_data(economic_profiles_object, data_type, year, data_format, number)
      end
    end
  end

  def add_lunch_data(economic_profile_object, data_type, year, data_format, number)
    if economic_profile_object.attributes[data_type].nil?
      economic_profile_object.attributes[data_type] = {year => {data_format => year}}
    elsif economic_profile_object.attributes[data_type][year].nil?
      economic_profile_object.attributes[data_type][year] = {data_format => year}
    elsif economic_profile_object.attributes[data_type][year][data_format].nil?
      economic_profile_object.attributes[data_type][year][data_format] =  number
    else
      economic_profile_object.attributes[data_type][year][data_format] = number
    end
  end

  def read_title_file(data, filepath, index)
    #refactor
    CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
      name = row[:location].upcase
      year = row[:timeframe].to_i
      percent = "N/A"
      percent = row[:data].to_f if row[:data] != "N/A"
      percent = row[:data].to_i if row[:data] == 1
      data_type = data_types.values[index]
      economic_profiles_object = find_by_name(name)
      if economic_profiles_object == nil
        economic_profiles[name] = EconomicProfile.new({:name => name, data_type => {year => percent}})
      else
        add_title_data(economic_profiles_object, data_type, year, percent)
      end
    end
  end

  def add_title_data(economic_profile_object, data_type, year, percent)
    if economic_profile_object.attributes[data_type].nil?
      economic_profile_object.attributes[data_type] = {year => percent}
    elsif economic_profile_object.attributes[data_type][year].nil?
      economic_profile_object.attributes[data_type][year] = percent
    else
      economic_profile_object.attributes[data_type][year] = percent
    end
  end

  def find_by_name(district_name)
    economic_profiles[district_name]
  end

  def check_loadpath(data, filepath, index)
    if filepath.include?("income")
      read_income_file(data, filepath, index)
    elsif filepath.include?("poverty")
      read_poverty_file(data, filepath, index)
    elsif filepath.include?("lunch")
      read_lunch_file(data, filepath, index)
    elsif filepath.include?("Title")
      read_title_file(data, filepath, index)
    end
  end
end
