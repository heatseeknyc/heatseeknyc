require 'capybara/poltergeist'
require 'pry'

class ScrapeDriver < DelegateClass(Capybara::Session)
  CHROME_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_0) 
    AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1664.3 Safari/537.36"

  def initialize()
    Capybara.register_driver :chrome_like do |app|  
      Capybara::Poltergeist::Driver.new(app).tap do |driver|
        driver.add_header("User-Agent", CHROME_AGENT)
      end
    end

    @actor = Capybara::Session.new(:chrome_like)
    super(@actor)
  end 

end