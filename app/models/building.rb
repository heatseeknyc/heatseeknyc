class Building < ActiveRecord::Base
  has_many :units
  has_many :tenants, through: :units, class_name: User.name

  validates_presence_of :street_address, :zip_code
  validates_format_of :zip_code,
                      with: /\A\d{5}-\d{4}|\A\d{5}\z/,
                      message: "should be 12345 or 12345-1234"
  validates :street_address, uniqueness: { scope: :zip_code, case_sensitive: false }

  before_save { |building| building.street_address = building.street_address.downcase }
end
