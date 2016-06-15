module DataParser

  def load_file_data(data)
    data.values[0].values.each_with_index do |filepath, index|
      check_loadpath(data, filepath, index)
    end
  end

  def check_loadpath(data, filepath, index)
    if filepath.include?("grade")
      read_grade_file(data, filepath, index)
    else
      read_race_file(data, filepath, index)
    end
  end

  def find_name(row)
    row[:location]
  end

  def find_sub_grade(row)
    row[:score].downcase.to_sym
  end

  def find_sub_race(data, index)
    data.values[0].keys[index].to_sym
  end

  def find_year(row)
    row[:timeframe].to_i
  end

  def find_year_collection(row)
    row[:timeframe].split("-").map { |num| num.to_i }
  end

  def find_data_format(row)
    if row[:dataformat] == "Percent"
      data_format = :percentage
    else
      data_format = :total
    end
  end

  def find_number(row, data_format)
    number = "N/A"
    if data_format == :percentage
    number = row[:data].to_f if row[:data] != "N/A"
    else
    number = row[:data].to_i if row[:data] != "N/A"
    end
    number
  end

  def find_percent(row)
    percent = "N/A"
    percent = truncate_float(row[:data].to_f) if row[:data] != "N/A"
    percent
  end

  def find_income(row)
    income = "N/A"
    income = row[:data].to_i if row[:data] != "N/A"
    income
  end

  def find_grade(index)
    test_results.values[index]
  end

  def find_ethnicity(row)
    test_results[row[:race_ethnicity].upcase].to_sym
  end

  def find_income(row)
    income = "N/A"
    income = row[:data].to_i if row[:data] != "N/A"
    income
  end

  def find_data_types(data_types, index)
    data_types.values[index]
  end


  def create_statewide_object(name, category, year, subject, percent, object)
    unless object
      input = {:name => name, category=> {year => {subject => percent}}}
      statewide_tests[name] = StatewideTest.new(input)
    else
      add_data(object, category, year, subject, percent)
    end
  end

  def create_economic_income_object(object, name, data_type, year, income)
    unless object
      input = {:name => name, data_type => {year => income}}
      economic_profiles[name] = EconomicProfile.new(input)
    else
      add_economic_data(object, data_type, year, income)
    end
  end

  def create_poverty_object(object, name, year, data_format, number, data_type)
    if object == nil
    economic_profiles[name] = EconomicProfile.new({:name => name, data_type  =>{year => {data_format => number}}})
    else
      add_poverty_data(object, data_type, year, data_format, number)
    end
  end

  def object_category_exists?(object, category)
    object.attributes[category].nil?
  end

  def object_data_type_exists?(object, data_type)
    object.attributes[data_type].nil?
  end

  def add_year_data_format_number(object, data_type, year, data_format, number)
    object.attributes[data_type] = {year => {data_format => number}}
  end

  def add_year_subject_data(object, category, year, subject, data)
    object.attributes[category] = {year => {subject => data}}
  end

  def add_year_data(object, category, year, data)
    object.attributes[category] = {year => data}
  end

  def object_year_exists?(object, category, year)
    object.attributes[category][year].nil?
  end

  def add_subject_and_data(object, category, year, subject, data)
    object.attributes[category][year] = { subject => data }
  end

  def add_number_or_percent(object, category, year, subject, percent)
    object.attributes[category][year][subject] = percent
  end

  def data_format_exists?(object, data_type, year, data_format)
    object.attributes[data_type][year][data_format].nil?
  end

  def add_data_to_year(object, category, year, data)
    object.attributes[category][year] = data
  end

  def add_income_data_to_object(object, category, year, data)
    if object_category_exists?(object, category)
      add_year_data(object, category, year, data)
    elsif object_year_exists?(object, category, year)
      add_data_to_year(object, category, year, data)
    else
      add_data_to_year(object, category, year, data)
    end
  end

  def add_poverty_data_to_object(object, data_type, year, data_format, number)
    if object_data_type_exists?(object, data_type)
      add_year_data_format_number(object, data_type, year, data_format, number)
    elsif object_year_exists?(object, data_type, year)
      add_subject_and_data(object,data_type, year, data_format, number)
    elsif data_format_exists?(object, data_type, year, data_format)
      add_number_or_percent(object, data_type, year, data_format, number)
    else
      add_number_or_percent(object, data_type, year, data_format, number)
    end
  end
end
