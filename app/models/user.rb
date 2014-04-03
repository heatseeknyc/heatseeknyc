class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :readings
  has_one :twine

  has_many :collaborations, dependent: :destroy
  has_many :collaborators, through: :collaborations, dependent: :destroy

  validates :first_name, :length => {minimum: 2}
  validates :last_name, :length => {minimum: 2}
  validates_presence_of :address, :email, :zip_code

  before_save :create_search_names

  include Timeable::InstanceMethods
  include Measurable::InstanceMethods
  include Graphable::InstanceMethods
  include Regulatable::InstanceMethods

  PERMISSIONS = {
    admin: 25,
    lawyer: 50,
    user: 100
  }

  def twine_name=(twine_name)
    return nil if twine_name == ""
    temp_twine = Twine.find_by(:name => twine_name)
    temp_twine.user(self.id)
    self.update(twine: temp_twine)
  end

  def twine_name
    self.twine.name unless self.twine.nil?
  end

  def has_collaboration?(collaboration_id)
    collaboration = find_collaboration(collaboration_id)
    # !collaboration.empty? && collaboration.confirmed
  end

  def find_collaboration(collaboration_id)
    self.collaborations.where(id: collaboration_id)
  end

  def admin?
    self.permissions <= 25
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

  def most_recent_temp
    self.readings.last.temp
  end

  def has_readings?
    !self.readings.empty?
  end
end
