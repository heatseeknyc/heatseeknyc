class Building < ActiveRecord::Base
  has_many :units
  has_many :tenants, class_name: User.name

  validates_presence_of :street_address, :zip_code
  validates_format_of :zip_code,
                      with: /\A\d{5}-\d{4}|\A\d{5}\z/,
                      message: "should be 12345 or 12345-1234"
  validates :street_address, uniqueness: { scope: :zip_code, case_sensitive: false }

  geocoded_by :zip_code
  after_validation :geocode

  reverse_geocoded_by :latitude, :longitude do |building, results|
    if geo = results.first
      building.city = geo.city
      building.state = geo.state
    end
  end
  after_validation :reverse_geocode

  def self.for_tenant(tenant)
    Building.where("street_address ILIKE '%#{tenant.address}%'").first
  end
end
