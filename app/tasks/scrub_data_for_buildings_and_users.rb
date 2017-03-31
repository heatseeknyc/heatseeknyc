class ScrubDataForBuildingsAndUsers

  STREET_RULES = {
    "east"   => "E",
    "e."     => "E",
    "west"   => "W",
    "w."     => "W",
    "north"  => "N",
    "n."     => "N",
    "south"  => "S",
    "s."     => "S",
    "avenue" => "Ave",
    "ave."   => "Ave",
    "street" => "St",
    "st."    => "St",
    "apt."   => "Apt",
    "place"  => "Pl",
    "road"   => "Rd"
  }

  AROUND_UNIT_RULES = {
    /(apt\s\S+)/   => ', \1,',
    /(apt\.\s\S+)/ => ', \1,',
    /(suite\s\S+)/ => ', \1,',
    /(\S+\sfloor)/ => ', \1,'
  }

  BEFORE_UNIT_RULES = {
    /\s(Apt\s\S+)/        => ', \1',
    /\s(Suite\s\S+)/      => ', \1',
    /(\s{1,1}\S+\sFloor)/ => ',\1',
    /(\s{1,1}#\d+)/       => ',\1'
  }

  STATES = [
    'ny',
    'new york',
    'pa',
    'pennsylvania'
  ]

  BEFORE_STATE_RULES = STATES.inject({}) do |hash, state|
    hash[/[a-zA-Z\d](\s#{state}$)/] = ', \1'
    hash
  end

  def self.exec(timeout)
    scrub_building_addresses(timeout)
    scrub_user_data(timeout)
  end

  def self.scrub_building_addresses(timeout)
    Building.all.each do |building|
      sleep timeout
      if update_address(building)
        p "Building at #{building.street_address} updated!"
      else
        delete_if_duplicate(building)
      end
    end
  end

  def self.scrub_user_data(timeout)
    User.all.each do |user|
      sleep timeout
      if update_user(user)
        p "User at #{user.address} updated!"
      else
        p "Error updating #{user.first_name} #{user.last_name} at #{user.address}"
      end
    end
  end

  def self.update_user(user)
    scrubbed_address = address_scrubber(user.address)
    abbreviated_address = address_up_until_comma(scrubbed_address)
    building_params = { street_address: abbreviated_address, zip_code: user.zip_code }

    building = Building.find_by building_params
    unless building
      building = Building.new building_params
    end
    building.set_location_data
    building.save

    user.update(
      address: scrubbed_address,
      first_name: user.first_name.strip,
      last_name: user.last_name.strip,
      building: building
    )
  end

  def self.address_up_until_comma(address)
    address.split(',')[0]
  end

  def self.update_address(building)
    scrubbed_address = address_scrubber(building.street_address)
    abbreviated_address = address_up_until_comma(scrubbed_address)

    building.update(
      street_address: abbreviated_address
    )

    building.set_location_data
    building.save
  end

  def self.delete_if_duplicate(building)
    if building.errors.messages[:street_address] && building.errors.messages[:street_address].include?('has already been taken')
      p "Building at #{building.street_address} deleted!"
      building.destroy
    end
  end

  def self.address_scrubber(address)
    zip_removed_string = remove_zip(downcase_and_strip(address))

    no_city_and_state_words = remove_city_and_state(add_comma_before_state(add_commas_around_units(zip_removed_string)))

    no_commas = to_ordinal(no_city_and_state_words.join(' ').split(/\s+/))
      .map { |word| STREET_RULES[word.gsub(',', '')] || word.gsub(',', '').capitalize }
      .join(' ')

    add_commas_before_units(no_commas)
  end

  def self.downcase_and_strip(address)
    address
      .strip
      .downcase
  end

  def self.remove_zip(address)
    address = address[0...-5].strip if address.match(/\s\d{5,5}\z/)
    address
  end

  def self.add_commas_around_units(address)
    AROUND_UNIT_RULES.each do |regex, replacement|
      address.gsub!(regex, replacement)
    end

    address
  end

  def self.add_comma_before_state(address)
    BEFORE_STATE_RULES.each do |regex, replacement|
      address.gsub!(regex, replacement)
    end

    address
  end

  def self.add_commas_before_units(address)
    BEFORE_UNIT_RULES.each do |regex, replacement|
      address.gsub!(regex, replacement)
    end
    address
  end

  def self.remove_city_and_state(address)
    address_sections = address.split(',').map(&:strip)
    address_sections = address_sections[0...-2] if STATES.include?(address_sections.last)
    address_sections
  end

  def self.to_ordinal(words)
    last_index = words.length - 1
    words.map.with_index do |word, i|
      if i == 0 || i == last_index || word.to_i == 0
        word
      else
        word.to_i.ordinalize
      end
    end
  end
end
