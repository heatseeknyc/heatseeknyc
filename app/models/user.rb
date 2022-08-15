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

  validates :first_name, :length => { minimum: 2 }
  validates :last_name, :length => { minimum: 2 }
  #validate :sensor_codes_string_contains_only_valid_sensors
  validates_presence_of :address, :email, :zip_code
  validates_format_of :zip_code,
                      with: /\A\d{5}-\d{4}|\A\d{5}\z/,
                      message: "should be 12345 or 12345-1234",
                      allow_blank: true
  validates :sms_alert_number,
            format: { with: /\A\+?[1-9]\d{1,14}\z/,
                      message: 'must be E.164 format, e.g. +17241134455',
                      allow_blank: true }

  before_save :create_search_names
  # before_validation :associate_sensors

  before_destroy :destroy_all_collaborations

  include Timeable::InstanceMethods
  include Measurable::InstanceMethods
  extend Measurable::ClassMethods
  include Graphable::InstanceMethods
  include Regulatable::InstanceMethods
  extend Regulatable::ClassMethods
  include Permissionable::InstanceMethods
  include Messageable::InstanceMethods

  PERMISSIONS = {
    super_user: 0,
    team_member: 10,
    admin: 25,
    advocate: 50,
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

  def self.new_with_building(params)
    set_location = params.delete(:set_location_data)
    user = self.new params
    building_params = { street_address: user.address, zip_code: user.zip_code }
    building = Building.find_by building_params

    unless building
      building = Building.new building_params
      building.set_location_data if set_location == 'true'
    end

    user.building = building
    user
  end

  def search(search)
    search_arr = search.downcase.split
    first_term = search_arr[0]
    second_term = search_arr[1] || search_arr[0]

    result = User.fuzzy_search(first_term, second_term).except_user_id(id).tenants_only.where.not(id:  collaborators.pluck(:id))

    is_demo_user? ? result.demo_users : result
  end

  def role
    PERMISSIONS.invert[permissions]
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

  def create_search_names
    self.search_first_name = first_name.downcase
    self.search_last_name = last_name.downcase
  end

  def live_readings
    readings.order(created_at: :desc).limit(50).sort_by do |r|
      r.violation = true
      r.created_at
    end
  end

  def current_temp
    @current_temp ||= self.readings.order(:created_at => :desc, :id => :desc).limit(1).first.try :temp
  end

  def current_temp_string
    current_temp ? "#{current_temp}°" : "N/A"
  end

  def current_temp_is_severe
    current_temp ? current_temp <= 60 : false
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

  def last_weeks_readings
    readings.where("created_at > ?", 7.days.ago).order(created_at: :asc)
  end

  def name
    "#{first_name} #{last_name}"
  end

  def name_and_email
    "#{last_name}, #{first_name} <#{email}>"
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

  def collaborations_with_violations
    recent_violations = Reading
                       .where("readings.created_at > ?", 7.days.ago)
                       .where(violation: true).to_sql

    users_with_recent_violations = User.select("users.id, COUNT(readings.id) as violations_count")
                    .joins("LEFT OUTER JOIN (#{recent_violations}) AS readings ON readings.user_id = users.id")
                    .group("users.id").to_sql

    @collaborations_with_violations ||= begin
      collaborations
        .joins("INNER JOIN (#{users_with_recent_violations}) users ON users.id = collaborations.collaborator_id")
        .select("collaborations.*, users.violations_count AS violations_count")
        .order("violations_count desc")
        .includes(:collaborator)
    end
  end

  def get_oldest_reading_date(format)
    if last_reading = self.readings.order(:created_at, :id).limit(1).first
      last_reading.created_at.strftime(format)
    end
  end

  def first_reading_this_year(format)
    if last_reading = self.readings.this_year.order(:created_at, :id).limit(1).first
      last_reading.created_at.strftime(format)
    end
  end

  def get_newest_reading_date(format)
    if newest_reading = self.readings.order(:created_at => :desc, :id => :desc).limit(1).first
      newest_reading.created_at.strftime(format)
    end
  end

  def get_collaboration_with_user(user)
    self.collaborations.find_by(collaborator: user)
  end

  def available_pdf_reports
    ActiveRecord::Base.connection.execute(
      <<-SQL
        SELECT
          CASE WHEN (EXTRACT(month from created_at))::int > 9
               THEN extract(year from created_at)::int + 1
               ELSE extract(year from created_at)::int
            END as date_part
        FROM readings
        WHERE user_id = #{id}
        GROUP BY
          CASE WHEN (EXTRACT(month from created_at))::int > 9
               THEN extract(year from created_at)::int + 1
               ELSE extract(year from created_at)::int
            END;
      SQL
    ).to_a.map { |r| r["date_part"].to_i }.map do |year|
      [year-1, year]
    end
  end

  def generate_password_reset_token
    raw_token = set_reset_password_token # this is protected, so we have to create another method
    raw_token
  end
end
