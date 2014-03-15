class User < ActiveRecord::Base
  has_many :readings
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :address
  validates_presence_of :email


  def twine
    
  end
end
