class Unit < ActiveRecord::Base
  belongs_to :building
  has_many :tenants, class_name: User.name, dependent: :restrict_with_exception

  validates_presence_of :building, :name
  validates :name, uniqueness: { scope: :building, case_sensitive: false }

  before_save { |unit| unit.name = unit.name.downcase }

  def can_destroy?
    tenants.empty?
  end

  def options_for_select_in_building
    {}.tap do |options|
      building.units.each do |unit|
        options[unit.name.upcase] = unit.id
      end
    end
  end
end
