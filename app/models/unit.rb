class Unit < ActiveRecord::Base
  belongs_to :building
  has_many :tenants, class_name: User.name

  validates_presence_of :building, :name
  validates :name, uniqueness: { scope: :building, case_sensitive: false }

  before_save { |unit| unit.name = unit.name.downcase }
end
