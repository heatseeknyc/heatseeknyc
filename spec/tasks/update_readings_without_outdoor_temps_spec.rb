require 'spec_helper'

describe UpdateReadingsWithoutOutdoorTemps do
  describe ".exec" do
    before do
      create(:reading)
      create(:reading)
      create(:reading, outdoor_temp: nil)
      create(:reading, outdoor_temp: nil)
    end

    it "updates readings without outdoor temps" do
      VCR.use_cassette('wunderground') do
        expect(Reading.where.not(outdoor_temp: nil).count).to eq 2
        expect(Reading.where(outdoor_temp: nil).count).to eq 2
        UpdateReadingsWithoutOutdoorTemps.exec(throttle: 0)
        expect(Reading.where.not(outdoor_temp: nil).count).to eq 4
        expect(Reading.where(outdoor_temp: nil).count).to eq 0
      end
    end
  end
end
