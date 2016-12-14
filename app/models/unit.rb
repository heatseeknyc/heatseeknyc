class Unit < ActiveRecord::Base
  belongs_to :building
  has_many :tenants, class_name: User.name, dependent: :restrict_with_exception

  validates_presence_of :building, :name
  validates :name, uniqueness: { scope: :building, case_sensitive: false }

  before_save { |unit| unit.name = unit.name.downcase }

  def can_destroy?
    tenants.empty?
  end

  def display_name_with_building
    "#{building.street_and_zip} - #{name.upcase}"
  end

  def options_for_select_in_building
    {}.tap do |options|
      building.units.each do |unit|
        options[unit.name.upcase] = unit.id
      end
    end
  end

  def self.options_for_select
    {}.tap do |options|
      all.each do |unit|
        options[unit.display_name_with_building] = unit.id
      end
    end.sort(&:k)
  end
end
