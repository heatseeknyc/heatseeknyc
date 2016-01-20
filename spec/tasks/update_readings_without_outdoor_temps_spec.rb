require 'spec_helper'

describe UpdateReadingsWithoutOutdoorTemps do
  describe ".exec" do
    before(:all) do
      Timecop.travel(DateTime.parse('2016-01-01 00:00:00 -0500'))
    end

    after(:all) do
      Timecop.travel(DateTime.parse('2015-03-01 00:00:00 -0500'))
    end

    it "updates readings without outdoor temps", :vcr do
      create(:reading)
      create(:reading)
      create(:reading, outdoor_temp: nil)
      create(:reading, outdoor_temp: nil)

      expect(Reading.where.not(outdoor_temp: nil).count).to eq 2
      expect(Reading.where(outdoor_temp: nil).count).to eq 2
      UpdateReadingsWithoutOutdoorTemps.exec(throttle: 0)
      expect(Reading.where.not(outdoor_temp: nil).count).to eq 4
      expect(Reading.where(outdoor_temp: nil).count).to eq 0
    end
  end
end
