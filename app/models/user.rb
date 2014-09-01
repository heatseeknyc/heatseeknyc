#encoding: utf-8

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :readings
  has_one :twine
  has_many :sensors

  has_many :collaborations, dependent: :destroy
  has_many :collaborators, through: :collaborations

  validates :first_name, :length => {minimum: 2}
  validates :last_name, :length => {minimum: 2}
  validates_presence_of :address, :email, :zip_code

  before_save :create_search_names

  before_destroy :destroy_all_collaborations

  include Timeable::InstanceMethods
  include Measurable::InstanceMethods
  extend Measurable::ClassMethods
  include Graphable::InstanceMethods
  include Regulatable::InstanceMethods

  PERMISSIONS = {
    admin: 25,
    lawyer: 50,
    user: 100
  }

  METRICS = [:min, :max, :avg]
  CYCLES = [:day, :night]
  MEASUREMENTS = [:temp, :outdoor_temp]
  DEMO_ACCOUNT_EMAILS = [
    'demo-user@heatseeknyc.com',
    'demo-lawyer@heatseeknyc.com',
     "jane@heatseeknyc.com",
     "john@heatseeknyc.com"
  ]
  
  define_measureable_methods(METRICS, CYCLES, MEASUREMENTS)

  def self.search(search)
    search_arr = search.downcase.split
    if search_arr[1] != nil
      where(['search_first_name LIKE ? OR search_last_name LIKE ?', "%#{search_arr[0]}%", "%#{search_arr[1]}%"])
    else
      where(['search_first_name LIKE ? OR search_last_name LIKE ?', "%#{search_arr[0]}%", "%#{search_arr[0]}%"])
    end
  end

  def self.account_demo_user?(user_id)
    DEMO_ACCOUNT_EMAILS.include?(User.find(user_id).email)
  end

  def twine_name=(twine_name)
    return nil if twine_name == ""
    temp_twine = Twine.find_by(:name => twine_name)
    temp_twine.user(self.id)
    self.update(twine: temp_twine)
  end

  def is_demo_user?
    DEMO_ACCOUNT_EMAILS.include?(self.email)
  end

  def twine_name
    self.twine.name unless self.twine.nil?
  end

  def has_collaboration?(collaboration_id)
    collaboration = find_collaboration(collaboration_id)
    !find_collaboration(collaboration_id).empty?
    # !collaboration.empty? && collaboration.confirmed
  end

  def find_collaboration(collaboration_id)
    self.collaborations.where(id: collaboration_id)
  end

  def admin?
    self.permissions <= 25
  end

  def lawyer?
    self.permissions <= 50
  end

  def create_search_names
    self.search_first_name = self.first_name.downcase
    self.search_last_name = self.last_name.downcase
  end

  def most_recent_temp
    self.readings.last.temp
  end

  def current_temp
    last_reading = self.readings.last
    if last_reading && last_reading.created_at > Time.now - 60 * 60 * 3
      "#{last_reading.temp}°"
    else
      "51°"  #CHANGE TO - - -°
    end
  end

  def has_readings?
    !self.readings.empty?
  end

  def destroy_all_collaborations
    Collaboration.where("user_id = ? OR collaborator_id = ?", self.id, self.id).destroy_all
  end

  # def method_missing(name, *args)
  #   name_keywords = name.to_s.match(/(min|max|avg)_(day|night)_(temp|outdoor_temp)/)
  #   if name_keywords
  #     array = self.send("get_cycle_#{name_keywords[3]}s", name_keywords[2].to_sym)
  #     self.send(name_keywords[1].to_sym, array)
  #   else
  #     super
  #   end
  # end

end
