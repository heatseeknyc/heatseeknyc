require 'spec_helper'

describe Twine do
  let(:twine) { create(:twine) }
  let(:user) { twine.user }
  
  it "has readings" do
    reading1 = create(:reading, twine: twine)
    reading2 = create(:reading, twine: twine)
    expect(twine.readings.count).to eq 2
  end

  describe "#get_reading" do
    let(:scraper) { double('scraper') }
    let(:twine_login_url) { "https://twine.cc/login?next=%2F" }
    let(:temperature) { 50 }
    let(:outside_temperature) { 45 }
    let(:html) { "<div class='temperature-value'>#{temperature}</div>" }
    let(:reading) { double('reading') }

    subject { twine.get_reading }

    before do
      allow(ScrapeDriver).to receive(:new).and_return scraper
      allow(scraper).to receive(:visit).with(twine_login_url)
      allow(scraper).to receive(:fill_in).with("email", { with: twine.email})
      allow(scraper).to receive(:fill_in).with("password", { with: "33west26"})
      allow(scraper).to receive(:click_button).with("signin")
      allow(scraper).to receive(:html).and_return html
      driver = double('driver')
      allow(scraper).to receive(:driver).and_return driver
      allow(driver).to receive(:quit)
      allow(twine).to receive(:sleep)
      allow(WeatherMan).to receive(:current_outdoor_temp).
                                       with(user.zip_code).
                                       and_return(outside_temperature)

      allow(Reading).to receive(:new_from_twine).
                                  with(temperature, twine.current_outdoor_temp, twine, user).
                                  and_return reading
      allow(reading).to receive(:save)
    end

    it "instantiates a new driver" do
      expect(ScrapeDriver).to receive(:new).and_return scraper
      subject
    end

    it "logs into twine.cc" do
      expect(scraper).to receive(:visit).with(twine_login_url)
      expect(scraper).to receive(:fill_in).with("email", { with: twine.email})
      expect(scraper).to receive(:fill_in).with("password", { with: "33west26"})
      expect(scraper).to receive(:click_button).with("signin")
      subject
    end

    it "fetches outside temperature" do
      expect(WeatherMan).to receive(:current_outdoor_temp).
                                       with(user.zip_code).
                                       and_return(outside_temperature)
      subject
    end

    it "creates a reading with scraped temperature, fetched outside temperature and user" do
      expect(Reading).to receive(:new_from_twine).
                                  with(temperature, twine.current_outdoor_temp, twine, user).
                                  and_return reading
      expect(reading).to receive(:save)
      subject
    end

    it "returns the reading" do
      expect(subject).to eql reading
    end

    context "no reading" do
      let(:html) { "<div class='temperature-value'></div>" }

      it "creates a reading with nil temperature" do
        expect(Reading).to receive(:new_from_twine).
                                    with(nil, twine.current_outdoor_temp, twine, user).
                                    and_return reading
        expect(reading).to receive(:save)
        subject
      end
    end

  #   it "makes a new reading" do
  #     twine_with_reading = create(:twine, email: "wm.jeffries+1@gmail.com")
  #     reading1 = twine_with_reading.get_reading
  #     expect(twine_with_reading.readings.first).to eq reading1
  #   end

  #   it "assigns readings to correct user" do
  #     twine1 = create(:twine)
  #     reading = twine1.get_reading
  #     expect(reading.user).to eq twine1.user
  #   end
  end
end
