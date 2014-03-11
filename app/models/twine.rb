class Twine < ActiveRecord::Base
  has_many :readings

  def chart_hash
      if readings.empty?
        {Time.now => 0}
      else
      chart_hash = readings.inject({}) do |log, reading| 
        log[reading.created_at] = reading.temp
        log
      end
    end
  end

  def min
    if self.readings.empty?
      0
    else
      self.readings.collect{|reading|reading.temp}.min
    end
  end

    def max
    if self.readings.empty?
      0
    else
      self.readings.collect{|reading|reading.temp}.max
    end
  end

  def range(margin = 5)
    {min: self.min - margin, max: self.max + margin}
  end

  def get_reading
    binding.pry
    session = ScrapeDriver.new
    session.visit 'https://twine.cc/login?next=%2F'
    session.fill_in 'email', :with => "wm.jeffries@gmail.com"
    session.fill_in 'password', :with => "33west26"
    sleep 1 + rand(1..10)/50
    session.click_button 'signin'
    sleep 5
    noko = Nokogiri::HTML(session.html)
    session.driver.quit
    temp = noko.css(".temperature-value").text.to_i
    self.readings.create(temp: temp)
  end
end
