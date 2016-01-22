require 'spec_helper'

describe HistoricalReading do
  let(:rate_limited_response) { {
    "response"=>{
      "version"=>"0.1",
      "termsofService"=>"http://www.wunderground.com/weather/api/d/terms.html",
      "features"=>{},
      "error"=>{
        "type"=>"invalidfeature",
        "description"=>"a requested feature is not valid due to exceeding rate plan"
      }
    }
  } }

  describe ".new_from_api" do
    it "raises errors if rate limited" do
      expect {
        HistoricalReading.new_from_api(Time.zone.now, rate_limited_response)
      }.to raise_error(HistoricalReading::RateLimited)
    end
  end

  describe '#temperature' do
    context "when observation for given time is present" do
      it "returns the temperature" do
        historical_reading = build(:historical_reading, :full_day)
        expect(historical_reading).to be_a HistoricalReading
        expect(historical_reading.temperature).to eq 39
      end
    end

    context "when observation for given time is missing" do
      it "returns nil" do
        historical_reading = build(:historical_reading)
        expect(historical_reading).to be_a HistoricalReading
        expect(historical_reading.temperature).to eq nil
      end
    end
  end
end
