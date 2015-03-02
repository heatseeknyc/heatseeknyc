class Twine < ActiveRecord::Base
  has_many :readings
  belongs_to :user

  def zip_code
    twine.user ? twine.user.zip_code : nil
  end
end
