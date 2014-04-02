class Reading < ActiveRecord::Base
  belongs_to :twine
  belongs_to :user

  validates :twine_id, presence: true
  validates :user_id, presence: true
  validates :temp, presence: true
  validates :outdoor_temp, presence: true

  def self.new_from_twine(temp, outside_temp, twine, user)
    new.tap do |r|
      r.temp = temp
      r.outside_temp = outside_temp
      r.twine = twine
      r.user = user
    end
  end
end