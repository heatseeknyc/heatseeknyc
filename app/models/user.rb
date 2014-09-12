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
    'mbierut@heatseeknyc.com',
    'bfried@heatseeknyc.com',
    'dhuttenlocher@heatseeknyc.com',
    'mkennedy@heatseeknyc.com',
    'kkimball@heatseeknyc.com',
    'mwiley@heatseeknyc.com',
    'dwinshel@heatseeknyc.com',
    'kjenkins@heatseeknyc.com',
    'enelson@heatseeknyc.com',
    'lbailey@heatseeknyc.com',
    'csanders@heatseeknyc.com',
    'jperry@heatseeknyc.com',
    'rwalker@heatseeknyc.com',
    'jwilliams@heatseeknyc.com',
    'aanderson@heatseeknyc.com',
    'bjackson@heatseeknyc.com',
    'nparker@heatseeknyc.com',
    'cstewart@heatseeknyc.com',
    'ahoward@heatseeknyc.com',
    'fmurphy@heatseeknyc.com',
    'srodriguez@heatseeknyc.com',
    'jgriffin@heatseeknyc.com',
    'sbryant@heatseeknyc.com',
    'abell@heatseeknyc.com',
    'cgonzalez@heatseeknyc.com',
    'rgray@heatseeknyc.com',
    'speterson@heatseeknyc.com',
    'sjones@heatseeknyc.com',
    'jhenderson@heatseeknyc.com',
    'nlong@heatseeknyc.com',
    'chernandez@heatseeknyc.com',
    'dmorgan@heatseeknyc.com',
    'demo-lawyer@heatseeknyc.com'
  ]
  
  define_measureable_methods(METRICS, CYCLES, MEASUREMENTS)

  def search(search)
    search_arr = search.downcase.split
    first_term = search_arr[0]
    second_term = search_arr[1] || search_arr[0]
    
    result = User.fuzzy_search(first_term, second_term).except_user_id(self.id).tenants_only
    
    self.is_demo_user? ? result.demo_users : result
  end

  def self.tenants_only
    where(permissions: 100)
  end

  def self.judges
    last_names = [
      "Bierut", 
      "Fried", 
      "Huttenlocher", 
      "Kennedy", 
      "Kimball", 
      "Wiley", 
      "Winshel"
    ]

    demo_users.where(last_name: last_names)
  end

  def self.fuzzy_search(first_term, second_term)
    where([
      'search_first_name LIKE ? OR search_last_name LIKE ?', 
      "%#{first_term}%", 
      "%#{second_term}%"
    ])
  end

  def self.except_user_id(user_id)
    where.not(id: user_id)
  end

  #TODO: eliminate this method and use is_demo_user? instance method instead
  def self.account_demo_user?(user_id) 
    DEMO_ACCOUNT_EMAILS.include?(User.find(user_id).email)
  end

  def self.create_demo_lawyer
    demo_lawyer = User.create(
      :first_name => "Demo Lawyer",
      :last_name => "Account",
      :address => "100 Fake St",
      :zip_code => "10004",
      :email => 'demo-lawyer@heatseeknyc.com',
      :password => '33west26',
      :permissions => 50
    )
  end

  def self.assign_demo_tenants_to(demo_lawyer)
    demo_tenants = demo_users.tenants_only.sample(5)

    demo_tenants.each do |demo_tenant|
      demo_lawyer.collaborators << demo_tenant
    end
  end

  def self.demo_lawyer
    demo_lawyer ||= find_by(first_name: 'Demo Lawyer') 
    
    if demo_lawyer.nil?
      demo_lawyer = create_demo_lawyer
      assign_demo_tenants_to(demo_lawyer)
    end
    
    return demo_lawyer
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

  def self.demo_users
    where(email: DEMO_ACCOUNT_EMAILS)
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

  def live_readings
    readings.order(created_at: :desc).limit(50).sort_by do |r| 
      r.violation = true
      r.created_at
    end
  end

  def current_temp
    last_reading = self.readings.last
    # bigapps version
    "#{last_reading.temp}°" if last_reading 
    # after bigapps uncomment this
    # if last_reading && last_reading.created_at > Time.now - 60 * 60 * 3
    #   "#{last_reading.temp}°"
    # else
    #   "- -"
    # end
  end

  def has_readings?
    !self.readings.empty?
  end

  def destroy_all_collaborations
    Collaboration.where("user_id = ? OR collaborator_id = ?", self.id, self.id).destroy_all
  end

  def get_latest_readings(num)
    readings.order('id ASC').limit(num)
  end

  def name
    "#{first_name} #{last_name}"
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
