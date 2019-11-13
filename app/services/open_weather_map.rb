class OpenWeatherMap
  include HTTParty
  @api_key = ENV["OPEN_WEATHER_MAP_KEY"]
  base_uri "https://api.openweathermap.org/data/2.5/weather?APPID=#{@api_key}&units=imperial"

  def conditions_for(zipcode)
    loc = OpenWeatherMap.get_loc_by_zip(zipcode)

    if loc
      self.class.get("&id=#{loc}")
    else
      self.class.get("&zip=#{zipcode},us")
    end
  end

  def self.get_loc_by_zip(zipcode)
    # location IDs are in a gzipped file here: http://bulk.openweathermap.org/sample/
    # Find a good matching ID for the zip's city and add it here

    # The mapping from zip to station here is a bit muddy. For now I'm using the first 3 
    # digits of a zip code, putting those in a range, and mapping those ranges to stations

    # Toronto starts with M4C
    return "6167865" if zipcode[0..2] == "M4C"

    # Montreal starts with H1
    return "6077243" if zipcode[0..1] == "H1"

    raise ArgumentError.new("invalid zip code #{zipcode}") if zipcode.length != 5

    # USA Zips
    z = zipcode[0..2].to_i

    if (100..102).include?(z)
      # NEW YORK, NY
      "5128638"
    elsif 103 == z
      # Staten Island, NY doesn't seem to have one, we use Brooklyn here instead
      "5110302"
    elsif 104 == z
      # Bronx, NY
      "5110253"
    elsif(105..110).include?(z)
      # Westchester county, orange, Nassau, uses Yonkers
      "5145215"
    elsif 111 == z
      # Queens, NY
      "5133268"
    elsif 112 == z
      # Brooklyn, NY
      "5110302"
    elsif (113..114).include?(z)
      # Queens, NY
      "5133268"
    elsif (115..118).include?(z)
      # Long Island, NY Nassau County
      "5128316"
    elsif (119..119).include?(z)
      # Long Island, NY suffolk county
      "4952349"
    elsif (120..129).include?(z)
      # Albany, NY area (way too wide, need to narrow this in the future if we're really up there)
      "5106841"
    else
      nil
    end
  end
end
