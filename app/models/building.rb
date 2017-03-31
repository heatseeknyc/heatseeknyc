class Building < ActiveRecord::Base
  has_many :units
  has_many :tenants, class_name: User.name

  validates_presence_of :street_address, :zip_code
  validates_format_of :zip_code,
                      with: /\A\d{5}-\d{4}|\A\d{5}\z/,
                      message: "should be 12345 or 12345-1234"
  validates :street_address, uniqueness: { scope: :zip_code, case_sensitive: false }

  NYC_BOROUGHS = [
      "Brooklyn",
      "Bronx",
      "Manhattan",
      "Staten Island",
      "Queens",
      "New York"
  ]

  geocoded_by :zip_code

  reverse_geocoded_by :latitude, :longitude do |building, results|
    if geo = results.first
      building.city = geo.city
      building.state = geo.state
    end
  end

  def set_location_data
    if zip_code.present?
      geocode
      reverse_geocode
    end

    if street_address.present? && zip_code.present? && NYC_BOROUGHS.include?(city)
      get_bbl
    elsif street_address.present? && zip_code.present?
      self.bbl = ""
    end
  end

  def get_bbl
    response = HTTParty.get(
        "https://api.cityofnewyork.us/geoclient/v1/address.json",
        { query: query_params.merge(access_params) }
    )
    begin
      payload = JSON.parse(response.body)["address"]

      self.bbl = payload["bbl"].gsub(/\D/, '')
    rescue
    end
  end

  private

    def query_params
      address = street_address.split(',')[0].split
      {
          houseNumber: address.shift,
          street: address.join(" "),
          zip: self.zip_code
      }
    end

    def access_params
      { app_id: ENV["GEOCLIENT_APP_ID"], app_key: ENV["GEOCLIENT_APP_KEY"] }
    end

    def self.for_tenant(tenant)
      Building.where("street_address ILIKE '%#{tenant.address}%'").first
    end
end
