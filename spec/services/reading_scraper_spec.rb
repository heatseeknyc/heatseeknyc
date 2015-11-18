require 'spec_helper'
require 'scrape_driver'
require 'reading_scraper'

describe ReadingScraper do
  let(:twine) { create(:twine) }

  describe "#get_reading" do
    let(:scraper) { double('scraper') }
    let(:twine_login_url) { "https://twine.cc/login?next=%2F" }
    let(:temperature) { 50 }
    let(:outside_temperature) { 45 }
    let(:html) { "<div class='temperature-value'>#{temperature}</div>" }
    let(:reading) { double('reading') }

    subject { ReadingScraper.new(twine) }

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
      allow(WeatherService).to receive(:current_outdoor_temp).
                                       with(twine.user.zip_code).
                                       and_return(outside_temperature)

      allow(Reading).to receive(:new_from_twine).
                                  with(temperature, outside_temperature, twine, twine.user).
                                  and_return reading
      allow(reading).to receive(:save)
      allow(subject).to receive(:sleep)
    end

    it "instantiates a new driver" do
      expect(ScrapeDriver).to receive(:new).and_return scraper
      subject.get_reading
    end

    it "logs into twine.cc" do
      expect(scraper).to receive(:visit).with(twine_login_url)
      expect(scraper).to receive(:fill_in).with("email", { with: twine.email})
      expect(scraper).to receive(:fill_in).with("password", { with: "33west26"})
      expect(scraper).to receive(:click_button).with("signin")
      subject.get_reading
    end

    it "fetches outside temperature" do
      expect(WeatherService).to receive(:current_outdoor_temp).
                                       with(twine.user.zip_code).
                                       and_return(outside_temperature)
      subject.get_reading
    end

    it "creates a reading with scraped temperature, fetched outside temperature and twine user" do
      expect(Reading).to receive(:new_from_twine).
                                  with(temperature, outside_temperature, twine, twine.user).
                                  and_return reading
      expect(reading).to receive(:save)
      subject.get_reading
    end

    it "returns the reading" do
      expect(subject.get_reading).to eql reading
    end

    context "no reading" do
      let(:html) { "<div class='temperature-value'></div>" }

      it "creates a reading with nil temperature" do
        expect(Reading).to receive(:new_from_twine).
                                    with(nil, outside_temperature, twine, twine.user).
                                    and_return reading
        expect(reading).to receive(:save)
        subject.get_reading
      end
    end
  end
end
