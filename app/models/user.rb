class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :readings
  has_one :twine
  has_many :user_collaborators
  has_many :collaborators, through: :user_collaborators

  has_many :collaborations
  has_many :collaborators, :through => :collaborations
  # has_many :inverse_collaborations, :class_name => "Collaboration", :foreign_key => "collaborator_id"
  # has_many :inverse_collaborators, :through => :inverse_collaborations, :source => :user

  validates :first_name, :length => {minimum: 2}
  validates :last_name, :length => {minimum: 2}
  validates_presence_of :address
  validates_presence_of :email

  before_save :create_search_names

  include Graphable::InstanceMethods

  def twine=(twine_name)
    #this lets forms work and will be used to assign twines 
    temp_twine = Twine.find_by(:name => twine_name)
    temp_twine.user(self.id)
  end

  def collaborator?(params_id)
    !self.collaborations.where(collaborator_id: params_id.to_i).empty?
  end

  def create_search_names
    self.search_first_name = self.first_name.downcase
    self.search_last_name = self.last_name.downcase
  end

  def self.search(search)
    search_arr = search.downcase.split
    if search_arr[1] != nil
      where(['search_first_name LIKE ? OR search_last_name LIKE ?', "%#{search_arr[0]}%", "%#{search_arr[1]}%"])
    else
      where(['search_first_name LIKE ? OR search_last_name LIKE ?', "%#{search_arr[0]}%", "%#{search_arr[0]}%"])
    end
  end


end
