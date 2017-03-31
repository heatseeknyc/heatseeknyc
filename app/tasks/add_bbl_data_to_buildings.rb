require "httparty"

class AddBBLDataToBuildings
  def self.exec(timeout)
    buildings_updated = 0

    Building.where("state = 'new york' OR state = 'New York'").each do |b|
      next if b.bbl

      response = HTTParty.get(
          "https://api.cityofnewyork.us/geoclient/v1/address.json",
          { query: query_params(b).merge(access_params) }
      )

      sleep timeout

      begin
        payload = JSON.parse(response.body)["address"]
        b.bbl = payload["bbl"].gsub(/\D/, '')
      rescue Exception => e
        puts "Error occurred with #{b.street_address}: #{response.code} #{response.message}"
        puts e.message
        next
      end

      if b.save
        buildings_updated += 1
        puts "Updated #{b.street_address}"
      end
    end

    puts "updated #{buildings_updated} of #{Building.count} buildings"
  end

  private

    def self.query_params(building)
      address = building.street_address.split(',')[0].split
      {
        houseNumber: address.shift,
        street: address.join(" "),
        zip: building.zip_code
      }
    end

    def self.access_params
      { app_id: ENV["GEOCLIENT_APP_ID"], app_key: ENV["GEOCLIENT_APP_KEY"] }
    end
end
