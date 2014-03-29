class Reading < ActiveRecord::Base
  belongs_to :twine
  belongs_to :user

  validates :twine_id, presence: true
  validates :user_id, presence: true
  validates :temp, presence: true

  def self.new_from_twine(temp, twine, user)
    new.tap do |r|
      r.temp = temp
      r.twine = twine
      r.user = user
    end
  end
end