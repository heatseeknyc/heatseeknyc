class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :readings
  has_one :twine

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :address
  validates_presence_of :email

  include Graphable::InstanceMethods

  def twine=(twine_name)
    #this lets forms work and will be used to assign twines 
    temp_twine = Twine.find_by(:name => twine_name)
    temp_twine.user(self.id)
  end
end
