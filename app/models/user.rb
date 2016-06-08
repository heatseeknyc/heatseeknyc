# encoding: utf-8

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :readings
  has_one :twine
  has_many :sensors
  belongs_to :building

  has_many :collaborations, dependent: :destroy
  has_many :collaborators, through: :collaborations

  belongs_to :unit
  delegate :building, to: :unit, allow_nil: true

  validates :first_name, :length => { minimum: 2 }
  validates :last_name, :length => { minimum: 2 }
  validate :sensor_codes_string_contains_only_valid_sensors
  validates_presence_of :address, :email, :zip_code
  validates_format_of :zip_code,
                      with: /\A\d{5}-\d{4}|\A\d{5}\z/,
                      message: "should be 12345 or 12345-1234",
                      allow_blank: true

  before_save :create_search_names
  before_validation :associate_sensors

  before_destroy :destroy_all_collaborations

  include Timeable::InstanceMethods
  include Measurable::InstanceMethods
  extend Measurable::ClassMethods
  include Graphable::InstanceMethods
  include Regulatable::InstanceMethods

  PERMISSIONS = {
    super_user: 0,
    team_member: 10,
    admin: 25,
    lawyer: 50,
    user: 100
  }.freeze

  METRICS = [:min, :max, :avg].freeze
  CYCLES = [:day, :night].freeze
  MEASUREMENTS = [:temp, :outdoor_temp].freeze
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
  ].freeze

  define_measureable_methods(METRICS, CYCLES, MEASUREMENTS)

  def search(search)
    search_arr = search.downcase.split
    first_term = search_arr[0]
    second_term = search_arr[1] || search_arr[0]

    result = User.fuzzy_search(first_term, second_term).except_user_id(id).tenants_only

    is_demo_user? ? result.demo_users : result
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

  # TODO: eliminate this method and use is_demo_user? instance method instead
  def self.account_demo_user?(user_id)
    DEMO_ACCOUNT_EMAILS.include?(User.find(user_id).email)
  end

  def self.create_demo_lawyer
    User.create(
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

  def associate_sensors
    sensors.clear
    string = sensor_codes_string || ""
    string.upcase.delete(" ").split(",").each do |nick_name|
      sensor = Sensor.find_by(nick_name: nick_name)
      sensors << sensor if sensor
    end
  end

  def sensor_codes
    sensors.map(&:nick_name).join(", ").upcase
  end

  def twine_name=(twine_name)
    return nil if twine_name == ""
    temp_twine = Twine.find_by(:name => twine_name)
    temp_twine.user(id)
    update(twine: temp_twine)
  end

  def is_demo_user?
    DEMO_ACCOUNT_EMAILS.include?(email)
  end

  def self.demo_users
    where(email: DEMO_ACCOUNT_EMAILS)
  end

  def twine_name
    twine.name unless twine.nil?
  end

  def has_collaboration?(collaboration_id)
    !find_collaboration(collaboration_id).empty?
  end

  def find_collaboration(collaboration_id)
    collaborations.where(id: collaboration_id)
  end

  def team_member?
    permissions <= PERMISSIONS[:team_member]
  end

  def admin?
    permissions <= PERMISSIONS[:admin]
  end

  def lawyer?
    permissions <= PERMISSIONS[:lawyer]
  end

  def list_permission_level_and_lower
    PERMISSIONS.select { |_k, v| v >= permissions }
  end

  def create_search_names
    self.search_first_name = first_name.downcase
    self.search_last_name = last_name.downcase
  end

  def most_recent_temp
    readings.last.temp
  end

  def live_readings
    readings.order(created_at: :desc).limit(50).sort_by do |r|
      r.violation = true
      r.created_at
    end
  end

  def current_temp
    last_reading = readings.last
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
    !readings.empty?
  end

  def destroy_all_collaborations
    Collaboration.where("user_id = ? OR collaborator_id = ?", id, id).destroy_all
  end

  def get_latest_readings(num)
    readings.order(created_at: :asc).last(num)
  end

  def name
    "#{first_name} #{last_name}"
  end

  def self.published_addresses(date_range)
    joins(:readings).where(permissions: 100, dummy: [nil, false]).
      order(address: :asc).where(readings: { created_at: date_range }).
      pluck(:address, :zip_code).uniq
  end

  def sensor_codes_string_contains_only_valid_sensors
    return if sensor_codes == (sensor_codes_string || "").upcase
    errors.add :sensor_codes_string, "has an invalid sensor code"
  end

  def inspect
    return super unless ENV["ANONYMIZED_FOR_LIVESTREAM"]
    super.
      gsub(", first_name: \"#{first_name}\"", "").
      gsub(", first_name: nil", "").
      gsub(", last_name: \"#{last_name}\"", "").
      gsub(", last_name: nil", "").
      gsub(", search_first_name: \"#{search_first_name}\"", "").
      gsub(", search_first_name: nil", "").
      gsub(", search_last_name: \"#{search_last_name}\"", "").
      gsub(", search_last_name: nil", "").
      gsub(", email: \"#{email}\"", "").
      gsub(", email: nil", "").
      gsub(", apartment: \"#{apartment}\"", "").
      gsub(", apartment: nil", "").
      gsub(", phone_number: \"#{phone_number}\"", "").
      gsub(", phone_number: nil", "")
  end
end
