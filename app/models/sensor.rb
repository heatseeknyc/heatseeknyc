class Sensor < ActiveRecord::Base
  belongs_to :user
  has_many :readings

  validates :name, uniqueness: true, presence: true

  def self.find_from_params(params)
  	find_by name: params[:name]
  end

  def self.create_from_params(params)
	user = User.find_by email: params[:email]
	name = params[:name]
	
	sensor = new.tap do |s| 
		s.name = params[:name]
		s.user = user
	end	

	sensor.save
	return sensor
  end

  def self.find_or_create_from_params(params)
  	find_from_params(params) || create_from_params(params)
  end
end
