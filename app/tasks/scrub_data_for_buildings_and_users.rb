class ScrubDataForBuildingsAndUsers

  ADDRESS_RULES = {
    "east" => "E",
    "e." => "E",
    "west"=> "W",
    "w."=> "W",
    "north"=> "N",
    "n."=> "N",
    "south"=> "S",
    "s."=> "S",
    "avenue"=> "Ave",
    "ave."=> "Ave",
    "street"=> "St",
    "st."=> "St"
  }

  def self.exec
    scrub_building_addresses
    scrub_user_data
  end

  def self.scrub_building_addresses
    Building.all.each do |building|
      sleep 1
      if update_address(building)
        p "Building at #{building.street_address} updated!"
      else
        delete_if_duplicate(building)
      end
    end
  end

  def self.scrub_user_data
    User.all.each do |user|
      sleep 1
      if update_user(user)
        p "User at #{user.address} updated!"
      else
        p "Error updating #{user.first_name} #{user.last_name} at #{user.address}"
      end
    end
  end

  def self.update_user(user)
    user.update(
      address: address_scrubber(user.address),
      first_name: user.first_name.strip,
      last_name: user.last_name.strip,
      building_id: find_or_create_building_for(user).id
    )
  end

  def self.update_address(building)
    building.update(
      street_address: address_scrubber(building.street_address)
    )
  end

  def self.delete_if_duplicate(building)
    if building.errors.messages[:street_address] && building.errors.messages[:street_address].include?('has already been taken')
      p "Building at #{building.street_address} deleted!"
      building.destroy
    end
  end

  def self.address_scrubber(address)
    words = tokenize(address)

    to_ordinal(words)
      .map{ |word| ADDRESS_RULES[word] || word.capitalize }
      .join(' ')
  end

  def self.tokenize(address)
    address
      .strip
      .downcase
      .split(/\s+/)
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

  def self.find_or_create_building_for(user)
    Building.where("street_address ILIKE '%#{user.address}%'").first ||
      Building.create(street_address: user.address, zip_code: user.zip_code)
  end
end
