class Twine < ApplicationRecord
  has_many :readings
  belongs_to :user

  def zip_code
    user ? user.zip_code : nil
  end
end
