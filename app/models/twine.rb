class Twine < ActiveRecord::Base
  has_many :readings
  belongs_to :user

  def get_reading
    session = ScrapeDriver.new
    session.visit 'https://twine.cc/login?next=%2F'
    session.fill_in 'email', :with => "wm.jeffries+1@gmail.com"
    session.fill_in 'password', :with => "33west26"
    sleep 1 + rand(1..10)/50
    session.click_button 'signin'
    sleep 5
    noko = Nokogiri::HTML(session.html)
    session.driver.quit
    temp = noko.css(".temperature-value").text.to_i
    new_reading = Reading.new
    new_reading.temp = temp
    new_reading.twine = self
    new_reading.user = self.user
    new_reading.save
  end
end
