class Building < ActiveRecord::Base
  has_many :units, dependent: :restrict_with_exception
  has_many :tenants, through: :units, class_name: User.name

  validates_presence_of :street_address, :zip_code
  validates_format_of :zip_code,
                      with: /\A\d{5}-\d{4}|\A\d{5}\z/,
                      message: "should be 12345 or 12345-1234"
  validates :street_address, uniqueness: { scope: :zip_code, case_sensitive: false }

  before_save { |building| building.street_address = building.street_address.downcase }

  def address_and_name
    [street_address.titlecase, zip_code, property_name].compact.join(" | ")
  end

  def street_and_zip
    [street_address.titlecase, zip_code].join(" | ")
  end

  def can_destroy?
    units.empty?
  end

  def self.options_for_select
    {}.tap do |options|
      all.each do |building|
        options[building.street_and_zip] = building.id
      end
    end
  end
end
